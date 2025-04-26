//
//  ZfVideoCachePlugin.h
//  Pods
//
//  Created by zf on 2025/4/25.
//

#import "ZfVideoCachePlugin.h"
#import <KTVHTTPCache/KTVHTTPCache.h>

@implementation ZfVideoCachePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"zf_video_cache_plugin"
            binaryMessenger:[registrar messenger]];
  ZfVideoCachePlugin* instance = [[ZfVideoCachePlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
    //初始化代理服务器
//    NSString *cachePath = [instance ktvCachePath];
//    [KTVHTTPCache cacheSetCacheDirectory:[NSURL fileURLWithPath:customPath]];
    NSError *error = nil;
    [KTVHTTPCache proxyStart:&error];
    if (error) {
        NSLog(@"KTVHTTPCache start error: %@", error);
    }
    [KTVHTTPCache encodeSetURLConverter:^NSURL *(NSURL *url) { return url; }];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  }else if ([@"getCachedUrl" isEqualToString:call.method]) {
      NSString *url = call.arguments[@"url"];
      NSString *proxyURL = [[KTVHTTPCache proxyURLWithOriginalURL:[NSURL URLWithString:url]] absoluteString];
      result(proxyURL);
    } else if ([@"clearCache" isEqualToString:call.method]) {
        [KTVHTTPCache cacheDeleteAllCaches];
      result(nil);
    } else if ([@"getCacheSize" isEqualToString:call.method]) {
     NSUInteger size =    [KTVHTTPCache cacheTotalCacheLength];
      result(@(size));
    }else  if ([@"preCacheVideo" isEqualToString:call.method]) {
        NSString *url = call.arguments[@"url"];
        NSInteger cacheSize = [call.arguments[@"cacheSize"] integerValue]; 

        [self preCacheVideoWithURL:url cacheSize:cacheSize];
        result(nil);
    } else {
    result(FlutterMethodNotImplemented);
  }
}


// 预缓存视频
- (void)preCacheVideoWithURL:(NSString *)urlString cacheSize:(NSInteger)cacheSize {
    NSURL *originalURL = [NSURL URLWithString:urlString];
    if (!originalURL) {
        NSLog(@"无效的 URL");
        return;
    }
    
    // 1. 生成代理 URL（KTVHTTPCache 会拦截此请求并缓存）
    NSURL *proxyURL = [KTVHTTPCache proxyURLWithOriginalURL:originalURL];

     // 2. 设置下载范围为前10MB
    NSInteger rangeEnd = cacheSize * 1024 * 1024 - 1; // 将 cacheSize 转换为字节数
    NSString *rangeHeader = [NSString stringWithFormat:@"bytes=0-%ld", (long)rangeEnd]; // 格式化范围字符串
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:proxyURL];
    [request setValue:rangeHeader forHTTPHeaderField:@"Range"]; // 动态设置 Range 请求头
    
    // 2. 发起一个虚假的下载任务（不存储数据，仅触发缓存）
    NSURLSessionDataTask *task = [[NSURLSession sharedSession]
                                   dataTaskWithRequest:request
                                   completionHandler:^(NSData * _Nullable data,
                                                       NSURLResponse * _Nullable response,
                                                       NSError * _Nullable error) {
        if (error) {
            NSLog(@"Preload failed: %@", error);
        } else {
            NSLog(@"Preload succeeded");
        }
    }];

    [task resume];
    NSLog(@"开始预缓存: %@", urlString);
}


@end
