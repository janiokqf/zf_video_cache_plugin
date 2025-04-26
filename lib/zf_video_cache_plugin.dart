import 'zf_video_cache_plugin_platform_interface.dart';

class ZfVideoCachePlugin {
  Future<String?> getPlatformVersion() {
    return ZfVideoCachePluginPlatform.instance.getPlatformVersion();
  }

  Future<String?> getProxyUrl(String originUrl) {
    return ZfVideoCachePluginPlatform.instance.getProxyUrl(originUrl);
  }

  Future<void> preCacheVideo(String originUrl,int cacheSize) {
    return ZfVideoCachePluginPlatform.instance.preCacheVideo(originUrl,cacheSize);
  }

  Future<void> clearCache(String originUrl) {
    return ZfVideoCachePluginPlatform.instance.clearCache();
  }

  Future<int?> getCacheSize() {
    return ZfVideoCachePluginPlatform.instance.getCacheSize();
  }
}
