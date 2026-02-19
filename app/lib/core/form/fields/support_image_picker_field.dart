import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lune/core/extensions/extensions.dart';
import 'package:lune/core/form/fields/reactive_multi_image_picker_field.dart';
import 'package:lune/core/ui/alerts/dialog/dialog.dart';
import 'package:lune/core/ui/alerts/snackbar/snackbar.dart';
import 'package:lune/core/ui/spacing/spacing.dart';
import 'package:lune/domain/repositories/repositories.dart';
import 'package:lune/l10n/l10n.dart';

class SupportImagePickerField extends StatelessWidget {
  const SupportImagePickerField({
    required this.formControlName,
    required this.permissionRepository,
    required this.dialog,
    super.key,
    this.maxImages = 10,
  });

  final String formControlName;
  final int maxImages;
  final PermissionRepository permissionRepository;
  final CustomDialog dialog;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ReactiveMultiImagePickerField(
      formControlName: formControlName,
      maxImages: maxImages,
      permissionRepository: permissionRepository,
      onError: (error) {
        SnackbarHelper.error(l10n.generalError);
      },
      builder: (
        context,
        images,
        isProcessing,
        pickFromGallery,
        pickFromCamera,
        removeImage,
      ) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.attachImages, style: context.textStyles.labelLarge),
            1.spaceY,
            Text(
              '${l10n.maxImages}: $maxImages',
              style: context.textStyles.bodySmall.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
            2.spaceY,
            if (images.isNotEmpty) ...[
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    final image = images[index];
                    return Container(
                      margin: EdgeInsets.only(right: 2.space),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(image.path),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () => removeImage(index),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: context.colors.error.withValues(
                                    alpha: 0.8,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(4),
                                child: Icon(
                                  Icons.close,
                                  size: 16,
                                  color: context.colors.onError,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              2.spaceY,
            ],
            if (images.length < maxImages) ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: isProcessing ? null : pickFromGallery,
                      icon: const Icon(Icons.photo_library),
                      label: Text(l10n.gallery),
                    ),
                  ),
                  2.spaceX,
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: isProcessing ? null : pickFromCamera,
                      icon: const Icon(Icons.camera_alt),
                      label: Text(l10n.camera),
                    ),
                  ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }
}
