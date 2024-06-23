import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'passport_reader_platform_interface.dart';

/// An implementation of [PassportReaderPlatform] that uses method channels.
class MethodChannelPassportReader extends PassportReaderPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('passport_reader');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
