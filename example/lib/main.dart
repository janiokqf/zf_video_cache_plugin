import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:zf_video_cache_plugin/zf_video_cache_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _zfVideoCachePlugin = ZfVideoCachePlugin();
  bool render = false;
  VideoPlayerController? _controller;
  late ChewieController  chewieController;
  List<String>  videPaths  = [
    "https://stantic.ifengqun.com/front/fq-ecmiddle-sys/upload/97bf9568c133e33a9c30f7308e9ea09c.mp4",
    "https://sf1-cdn-tos.huoshanstatic.com/obj/media-fe/xgplayer_doc_video/mp4/xgplayer-demo-360p.mp4",
    "https://stantic.ifengqun.com/front/fq-ecmiddle-sys/upload/f7da282d2f722a51838916ea3b19183c.mp4",
    "https://stantic.ifengqun.com/front/fq-ecmiddle-sys/upload/c7004758214e82ba3d9c3f58c382b6c6.mp4"
  ];
 

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  setVideo(String originUrl) async {

    String? url =  await _zfVideoCachePlugin.getProxyUrl(originUrl);
    print("代理地址？${url}",);
    if(url != null){
      render = false;
      
      setState(() {
      });
      
      ///下一针 渲染视频
         WidgetsBinding.instance.addPostFrameCallback((_) async {
                await _controller?.dispose(); //释放上一个视频播放器
                  _controller = VideoPlayerController.networkUrl(Uri.parse(url),)
                    ..initialize().then((_) {
                      chewieController = ChewieController(
                          videoPlayerController: _controller!,
                          autoPlay: true,
                          looping: true,
                        );
                      render = true;          
                      setState(() {});
                    });
          });
    

    }


  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _zfVideoCachePlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body:  Column(
          children: [
            Row(
              children: [
                GestureDetector(onTap: (){
                  videPaths.forEach((element) {
                    _zfVideoCachePlugin.preCacheVideo(element,10); //预加载这个视频 只加载前面的 10MB内容
                  });

                },child: Padding(padding: EdgeInsets.all(10),child: Text("预加载视频"),),),
              ],
            ),

            Container(
              width: double.infinity,
              height: 50,
              child:    ListView.builder(itemBuilder: (BuildContext context, int index){

               return   GestureDetector(onTap: (){
                    setVideo(videPaths[index]);
                },child: Padding(padding: EdgeInsets.all(10),child: Text("播放视频${index}",style: TextStyle(color: Colors.red),),),);

            },scrollDirection: Axis.horizontal,itemCount: videPaths.length,),
            ),
             Container(
              width: 300,
              height: 550,
              color: Colors.black,
              child: render?
             Chewie(
              controller: chewieController,
            ):SizedBox.shrink(),
             ),



          ],
        ),
      ),
    );
  }
}
