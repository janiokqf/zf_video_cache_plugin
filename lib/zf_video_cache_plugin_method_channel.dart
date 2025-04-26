
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'zf_video_cache_plugin_platform_interface.dart';

/// An implementation of [ZfVideoCachePluginPlatform] that uses method channels.
class MethodChannelZfVideoCachePlugin extends ZfVideoCachePluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('zf_video_cache_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
  @override
  Future<String?> getProxyUrl(String originUrl) async {
        final proxyUrl = await methodChannel.invokeMethod<String>('getCachedUrl',{'url': originUrl});
        return proxyUrl;
  }
  @override
  Future<void> preCacheVideo(String originUrl,int cacheSize) async {
         await methodChannel.invokeMethod('preCacheVideo',{'url': originUrl,"cacheSize":cacheSize});
  }
  @override
  Future<void> clearCache() async {
         await methodChannel.invokeMethod('clearCache');
  }
  @override
  Future<int?> getCacheSize() async {
        return await methodChannel.invokeMethod<int>('getCacheSize');
  }

}
