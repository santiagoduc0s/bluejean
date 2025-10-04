import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lune/core/ui/alerts/dialog/dialog.dart';
import 'package:lune/core/utils/utils.dart';
import 'package:lune/domain/enums/enums.dart';
import 'package:lune/domain/repositories/repositories.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ReactiveImagePickerField extends ReactiveFormField<XFile?, XFile?> {
  ReactiveImagePickerField({
    required String formControlName,
    required this.builder,
    required this.permissionRepository,
    super.key,
    this.imageQuality = 90,
    this.onError,
  }) : super(
         formControlName: formControlName,
         builder:
             (field) => _ImagePickerContent(
               field: field,
               imageQuality: imageQuality,
               customBuilder: builder,
               onError: onError,
               permissionRepository: permissionRepository,
             ),
       );

  final int imageQuality;
  final Widget Function(
    BuildContext context,
    XFile? image,
    bool isProcessing,
    VoidCallback pickFromGallery,
    VoidCallback pickFromCamera,
    VoidCallback removeImage,
  ) builder;

  final void Function(Object error)? onError;
  final PermissionRepository permissionRepository;
}

class _ImagePickerContent extends StatefulWidget {
  const _ImagePickerContent({
    required this.field,
    required this.imageQuality,
    required this.customBuilder,
    required this.permissionRepository,
    this.onError,
  });

  final ReactiveFormFieldState<XFile?, XFile?> field;
  final int imageQuality;
  final Widget Function(
    BuildContext context,
    XFile? image,
    bool isProcessing,
    VoidCallback pickFromGallery,
    VoidCallback pickFromCamera,
    VoidCallback removeImage,
  ) customBuilder;
  final void Function(Object error)? onError;
  final PermissionRepository permissionRepository;

  @override
  State<_ImagePickerContent> createState() => _ImagePickerContentState();
}

class _ImagePickerContentState extends State<_ImagePickerContent> {
  bool _isProcessing = false;

  Future<void> _pickImage(ImageSource source) async {
    setState(() => _isProcessing = true);

    final permissionType = source == ImageSource.camera
        ? PermissionType.camera
        : PermissionType.photos;

    try {
      var status = await widget.permissionRepository.check(permissionType);

      if (!mounted) return;

      if (status == PermissionStatus.permanentlyDenied) {
        final tr = AppProvider.get<Localization>().tr;

        final shouldOpen = await DialogHelper.confirm(
          message:
              source == ImageSource.camera
                  ? tr.cameraIsDisabled
                  : tr.galleryIsDisabled,
          confirmText: tr.goToSettings,
          cancelText: tr.cancel,
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
        final image = await picker.pickImage(
          source: source,
          imageQuality: widget.imageQuality,
        );
        if (image != null) {
          widget.field.didChange(image);
        }
      }
    } catch (e) {
      widget.onError?.call(e);
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  void _removeImage() {
    widget.field.didChange(null);
    widget.field.control.markAsTouched();
  }

  Future<void> _pickFromGallery() => _pickImage(ImageSource.gallery);
  Future<void> _pickFromCamera() => _pickImage(ImageSource.camera);

  @override
  Widget build(BuildContext context) {
    final image = widget.field.value;
    return widget.customBuilder(
      context,
      image,
      _isProcessing,
      _pickFromGallery,
      _pickFromCamera,
      _removeImage,
    );
  }
}
