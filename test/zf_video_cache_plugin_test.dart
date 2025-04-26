import 'package:flutter_test/flutter_test.dart';
import 'package:zf_video_cache_plugin/zf_video_cache_plugin.dart';
import 'package:zf_video_cache_plugin/zf_video_cache_plugin_platform_interface.dart';
import 'package:zf_video_cache_plugin/zf_video_cache_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockZfVideoCachePluginPlatform
    with MockPlatformInterfaceMixin
    implements ZfVideoCachePluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final ZfVideoCachePluginPlatform initialPlatform = ZfVideoCachePluginPlatform.instance;

  test('$MethodChannelZfVideoCachePlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelZfVideoCachePlugin>());
  });

  test('getPlatformVersion', () async {
    ZfVideoCachePlugin zfVideoCachePlugin = ZfVideoCachePlugin();
    MockZfVideoCachePluginPlatform fakePlatform = MockZfVideoCachePluginPlatform();
    ZfVideoCachePluginPlatform.instance = fakePlatform;

    expect(await zfVideoCachePlugin.getPlatformVersion(), '42');
  });
}
