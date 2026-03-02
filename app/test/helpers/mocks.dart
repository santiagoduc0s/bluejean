import 'dart:typed_data';

import 'package:lune/core/utils/nullable_parameter.dart';
import 'package:lune/domain/repositories/repositories.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockDeviceRepository extends Mock implements DeviceRepository {}

class MockMessagingRepository extends Mock implements MessagingRepository {}

class MockRemoteStorageRepository extends Mock
    implements RemoteStorageRepository {}

void registerFallbackValues() {
  registerFallbackValue(NullableParameter<String?>(null));
  registerFallbackValue(Uint8List(0));
}
