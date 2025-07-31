import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lune/core/ui/alerts/dialog/dialog.dart';
import 'package:lune/core/utils/utils.dart';
import 'package:lune/domain/enums/enums.dart';
import 'package:lune/domain/repositories/repositories.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ReactiveMultiImagePickerField
    extends ReactiveFormField<List<XFile>, List<XFile>> {
  ReactiveMultiImagePickerField({
    required String formControlName,
    required this.builder,
    required this.permissionRepository,
    required this.dialog,
    required this.localization,
    super.key,
    this.imageQuality = 90,
    this.maxImages = 10,
    this.onError,
  }) : super(
          formControlName: formControlName,
          builder: (field) => _MultiImagePickerContent(
            field: field,
            imageQuality: imageQuality,
            maxImages: maxImages,
            customBuilder: builder,
            onError: onError,
            permissionRepository: permissionRepository,
            dialog: dialog,
            localization: localization,
          ),
        );

  final int imageQuality;
  final int maxImages;
  final Widget Function(
    BuildContext context,
    List<XFile> images,
    bool isProcessing,
    VoidCallback pickFromGallery,
    VoidCallback pickFromCamera,
    void Function(int index) removeImage,
  ) builder;

  final void Function(Object error)? onError;
  final PermissionRepository permissionRepository;
  final CustomDialog dialog;
  final Localization localization;
}

class _MultiImagePickerContent extends StatefulWidget {
  const _MultiImagePickerContent({
    required this.field,
    required this.imageQuality,
    required this.maxImages,
    required this.customBuilder,
    required this.permissionRepository,
    required this.dialog,
    required this.localization,
    this.onError,
  });

  final ReactiveFormFieldState<List<XFile>, List<XFile>> field;
  final int imageQuality;
  final int maxImages;
  final Widget Function(
    BuildContext context,
    List<XFile> images,
    bool isProcessing,
    VoidCallback pickFromGallery,
    VoidCallback pickFromCamera,
    void Function(int index) removeImage,
  ) customBuilder;
  final void Function(Object error)? onError;
  final PermissionRepository permissionRepository;
  final CustomDialog dialog;
  final Localization localization;

  @override
  State<_MultiImagePickerContent> createState() =>
      _MultiImagePickerContentState();
}

class _MultiImagePickerContentState extends State<_MultiImagePickerContent> {
  bool _isProcessing = false;

  List<XFile> get _images => widget.field.value ?? <XFile>[];

  Future<void> _pickImage(ImageSource source) async {
    if (_images.length >= widget.maxImages) return;

    setState(() => _isProcessing = true);

    final permissionType = source == ImageSource.camera
        ? PermissionType.camera
        : PermissionType.photos;

    try {
      var status = await widget.permissionRepository.check(permissionType);

      if (!mounted) return;

      if (status == PermissionStatus.permanentlyDenied) {
        final shouldOpen = await widget.dialog.confirm(
          message: source == ImageSource.camera
              ? widget.localization.tr.cameraIsDisabled
              : widget.localization.tr.galleryIsDisabled,
          confirmText: widget.localization.tr.goToSettings,
          cancelText: widget.localization.tr.cancel,
        );

        if (shouldOpen) {
          await widget.permissionRepository.openSettings();
        }
        return;
      }

      if (status == PermissionStatus.denied) {
        status = await widget.permissionRepository.request(permissionType);
      }

      if (status == PermissionStatus.granted) {
        final picker = ImagePicker();
        
        if (source == ImageSource.camera) {
          // Camera can only take one image at a time
          final image = await picker.pickImage(
            source: source,
            imageQuality: widget.imageQuality,
          );
          if (image != null) {
            final newImages = List<XFile>.from(_images)..add(image);
            widget.field.didChange(newImages);
          }
        } else {
          // Gallery can select multiple images
          final remainingSlots = widget.maxImages - _images.length;
          final selectedImages = await picker.pickMultiImage(
            imageQuality: widget.imageQuality,
          );
          
          if (selectedImages.isNotEmpty) {
            // Limit the number of selected images to available slots
            final imagesToAdd = selectedImages.take(remainingSlots).toList();
            final newImages = List<XFile>.from(_images)..addAll(imagesToAdd);
            widget.field.didChange(newImages);
          }
        }
      }
    } catch (e) {
      widget.onError?.call(e);
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  void _removeImage(int index) {
    final newImages = List<XFile>.from(_images)..removeAt(index);
    widget.field.didChange(newImages);
    widget.field.control.markAsTouched();
  }

  Future<void> _pickFromGallery() => _pickImage(ImageSource.gallery);
  Future<void> _pickFromCamera() => _pickImage(ImageSource.camera);

  @override
  Widget build(BuildContext context) {
    final images = _images;
    return widget.customBuilder(
      context,
      images,
      _isProcessing,
      _pickFromGallery,
      _pickFromCamera,
      _removeImage,
    );
  }
}
