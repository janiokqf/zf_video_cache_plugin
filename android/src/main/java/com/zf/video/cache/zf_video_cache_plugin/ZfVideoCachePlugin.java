package com.zf.video.cache.zf_video_cache_plugin;


import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;

import com.danikula.videocache.HttpProxyCacheServer;
import com.danikula.videocache.preload.PreloadHelper;
import com.danikula.videocache.StorageUtils;

import java.io.File;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;




/** ZfVideoCachePlugin */
public class ZfVideoCachePlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private Context context;
  private HttpProxyCacheServer proxy;
  

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    context = flutterPluginBinding.getApplicationContext();
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "zf_video_cache_plugin");
    channel.setMethodCallHandler(this);
    proxy = getProxy(context); // 初始化代理服务器
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    switch (call.method) {
      case "getCachedUrl":
        String url = call.argument("url");
        result.success(proxy.getProxyUrl(url));
        break;

      case "clearCache":
        clearCacheDir(StorageUtils.getIndividualCacheDirectory(context));
        result.success(null);
        break;

      case "getCacheSize":
        long size = getFolderSize(StorageUtils.getIndividualCacheDirectory(context));
        result.success(size);
        break;

      case "preCacheVideo":
        String preloadUrl = call.argument("url");
        int cacheSize = call.argument("cacheSize");
        preCacheVideo(preloadUrl,cacheSize);
        result.success(null);
        break;
      case "getPlatformVersion":
        result.success("Android " + android.os.Build.VERSION.RELEASE);
        break;
      default:
        result.notImplemented();
    }

  }



  // 获取代理服务器（单例）
  private HttpProxyCacheServer getProxy(Context context) {
    if (proxy == null) {
      // proxy = new HttpProxyCacheServer(context);
      proxy = new HttpProxyCacheServer.Builder(context)
              .maxCacheSize(calculateDynamicCacheSize()) // 
              .build();
    }
    return proxy;
  }

  private long calculateDynamicCacheSize() {
    File cacheDir = context.getCacheDir();
    long usableSpace = cacheDir.getUsableSpace();

    // 分配 30%，限制最大为 10GB
    long cacheSize = usableSpace * 3 / 10;
    long maxLimit = 10L * 1024 * 1024 * 1024; // 10GB

    return Math.min(cacheSize, maxLimit);
}



  // 递归获取文件夹大小
  private long getFolderSize(File dir) {
    long size = 0;
    if (dir != null && dir.isDirectory()) {
      for (File file : dir.listFiles()) {
        if (file.isFile()) {
          size += file.length();
        } else {
          size += getFolderSize(file);
        }
      }
    }
    return size;
  }

  // 清除缓存目录
  private void clearCacheDir(File dir) {
    if (dir != null && dir.exists()) {
      for (File file : dir.listFiles()) {
        if (file.isDirectory()) {
          clearCacheDir(file);
        } else {
          file.delete();
        }
      }
    }
  }

  // 模拟预缓存（后台播放一次）
  private void preCacheVideo(String url,int cacheSize) {
   
      try {
        
        //设置预加载缓存大小 cacheSize 是mb级别的单位
        PreloadHelper.getInstance().setPreloadSize(cacheSize * 1024 * 1024);
        //加载制定url链接，url为源地址(非代理url)
        PreloadHelper.getInstance().load(proxy,url);

        Log.d("ZfVideoCachePlugin", "Preload succeeded: " + url);
      } catch (Exception e) {
        Log.e("ZfVideoCachePlugin", "Preload failed: " + e.getMessage());
      }
    
  }


  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
