import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lune/core/extensions/change_notifier_extension.dart';
import 'package:lune/domain/repositories/repositories.dart';
import 'package:reactive_forms/reactive_forms.dart';

class SupportNotifier extends ChangeNotifier {
  SupportNotifier({
    required SupportRepository supportRepository,
    required RemoteStorageRepository remoteStorageRepository,
  }) : _supportRepository = supportRepository,
       _remoteStorageRepository = remoteStorageRepository;

  final SupportRepository _supportRepository;
  final RemoteStorageRepository _remoteStorageRepository;

  bool _isCreatingTicket = false;
  bool get isCreatingTicket => _isCreatingTicket;

  final FormGroup form = FormGroup({
    'email': FormControl<String>(
      value: '',
      validators: [
        Validators.required,
        Validators.email,
      ],
    ),
    'title': FormControl<String>(
      value: '',
      validators: [Validators.required],
    ),
    'description': FormControl<String>(
      value: '',
      validators: [Validators.required],
    ),
    'images': FormControl<List<XFile>>(
      value: <XFile>[],
    ),
  });

  @override
  void dispose() {
    form.dispose();
    super.dispose();
  }

  Future<void> createTicket() async {
    if (!form.valid) {
      form.markAllAsTouched();
      return;
    }

    if (_isCreatingTicket) return;

    _isCreatingTicket = true;
    notifyListeners();

    try {
      final images = form.control('images').value as List<XFile>;
      final imageUrls = await Future.wait(
        images.asMap().entries.map((entry) async {
          final image = entry.value;
          final bytes = await File(image.path).readAsBytes();

          return _remoteStorageRepository.uploadFile(
            data: bytes,
            path: '/support_tickets',
          );
        }),
      );

      await _supportRepository.createTicket(
        email: form.control('email').value as String,
        title: form.control('title').value as String,
        description: form.control('description').value as String,
        images: imageUrls,
      );

      primarySnackbar(localization.ticketCreated);

      form.reset();
    } catch (e, s) {
      logError(e, s);
      errorSnackbar(localization.generalError);
    } finally {
      _isCreatingTicket = false;
      notifyListeners();
    }
  }
}
