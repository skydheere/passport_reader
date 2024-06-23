import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'passport_reader_method_channel.dart';

abstract class PassportReaderPlatform extends PlatformInterface {
  /// Constructs a PassportReaderPlatform.
  PassportReaderPlatform() : super(token: _token);

  static final Object _token = Object();

  static PassportReaderPlatform _instance = MethodChannelPassportReader();

  /// The default instance of [PassportReaderPlatform] to use.
  ///
  /// Defaults to [MethodChannelPassportReader].
  static PassportReaderPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PassportReaderPlatform] when
  /// they register themselves.
  static set instance(PassportReaderPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
