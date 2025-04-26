# zf_video_cache_plugin

A new Flutter plugin project.
Plugin that provides media caching capabilities
No intrusion, supports any player
一个提供视频 预加载和缓存 功能的Flutter 插件支持所有播放器



### Preload videos capability
```
ZfVideoCachePlugin().preCacheVideo(http_url,10);
```

### Caching your videos
```
    String? url =  await ZfVideoCachePlugin().getProxyUrl(originUrl);
    VideoPlayerController.networkUrl(Uri.parse(url),);
```

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter development, view the
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.



## Android needs to add these
1. add ` android:usesCleartextTraffic="true" ` into AndroidManifest.xml application;
2. add ` android:networkSecurityConfig="@xml/network_security_config" ` into AndroidManifest.xml application;
```
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <domain-config cleartextTrafficPermitted="true">
        <domain includeSubdomains="true">127.0.0.1</domain>
    </domain-config>
    <base-config cleartextTrafficPermitted="true">
        <trust-anchors>
            <certificates src="system" />
        </trust-anchors>
    </base-config>
</network-security-config>
```
3. add `<uses-library android:name="org.apache.http.legacy" android:required="false" />` into AndroidManifest.xml application;
