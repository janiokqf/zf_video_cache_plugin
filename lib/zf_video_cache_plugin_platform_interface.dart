import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'zf_video_cache_plugin_method_channel.dart';

abstract class ZfVideoCachePluginPlatform extends PlatformInterface {
  /// Constructs a ZfVideoCachePluginPlatform.
  ZfVideoCachePluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static ZfVideoCachePluginPlatform _instance = MethodChannelZfVideoCachePlugin();

  /// The default instance of [ZfVideoCachePluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelZfVideoCachePlugin].
  static ZfVideoCachePluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ZfVideoCachePluginPlatform] when
  /// they register themselves.
  static set instance(ZfVideoCachePluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> getProxyUrl(String originUrl) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
  Future<void> preCacheVideo(String originUrl,int cacheSize) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
  Future<void> clearCache() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<int?> getCacheSize() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  


}
