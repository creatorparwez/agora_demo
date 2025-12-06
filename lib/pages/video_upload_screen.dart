import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoUploadScreen extends StatefulWidget {
  final File videoFile;
  const VideoUploadScreen({super.key, required this.videoFile});

  @override
  State<VideoUploadScreen> createState() => _VideoUploadScreenState();
}

class _VideoUploadScreenState extends State<VideoUploadScreen> {
  final TextEditingController _titleController = TextEditingController();
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    // _controller = VideoPlayerController.file(widget.videoFile)
    //   ..initialize().then((_) {
    //     setState(() {});
    //   });
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    _videoPlayerController = VideoPlayerController.file(widget.videoFile);
    await _videoPlayerController.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: false,
      looping: false,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.red,
        handleColor: Colors.redAccent,
      ),
      hideControlsTimer: const Duration(seconds: 3),
    );
    setState(() {});
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double videoAspect = _videoPlayerController.value.aspectRatio;
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Video", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF132440),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            SizedBox(height: 20),
            Container(
              height: 350,
              width: 350 * videoAspect,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 2, color: Colors.grey),
              ),
              child:
                  _chewieController != null &&
                      _chewieController!
                          .videoPlayerController
                          .value
                          .isInitialized
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: _videoPlayerController.value.size.width,
                            height: _videoPlayerController.value.size.height,
                            child: Chewie(controller: _chewieController!),
                          ),
                        ),
                      ),
                    )
                  : Center(child: CircularProgressIndicator()),
            ),

            SizedBox(height: 15),
            TextFormField(
              controller: _titleController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Add a caption",

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF132440),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {},
              child: Center(
                child: Text("Upload", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
