import 'package:flutter_test/flutter_test.dart';
import 'package:passport_reader/passport_reader.dart';
import 'package:passport_reader/passport_reader_platform_interface.dart';
import 'package:passport_reader/passport_reader_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPassportReaderPlatform
    with MockPlatformInterfaceMixin
    implements PassportReaderPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final PassportReaderPlatform initialPlatform =
      PassportReaderPlatform.instance;

  test('$MethodChannelPassportReader is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelPassportReader>());
  });

  test('getPlatformVersion', () async {});
}
