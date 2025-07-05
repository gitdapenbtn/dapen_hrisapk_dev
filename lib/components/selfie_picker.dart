import 'dart:io';
import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:dpbtn_absen/layouts/constants/layout_color.dart';

import 'package:dpbtn_absen/main.dart';
import 'package:unicons/unicons.dart';

class SelfiePicker extends StatefulWidget {
  final ValueChanged<String> onTakePicture;
  const SelfiePicker({
    super.key,
    required this.onTakePicture,
  });

  @override
  State<SelfiePicker> createState() => _SelfiePickerState();
}

class _SelfiePickerState extends State<SelfiePicker> {
  late CameraController _controller;
  late Future<void> _controllerFuture;
  late CameraLensDirection _direction = CameraLensDirection.front;
  XFile? _image;
  int _cameraIndex = -1;

  @override
  void initState() {
    super.initState();
    _selectCamera();
    _init();
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(_controller.value.isInitialized == false) {
      return Container();
    }

    return FutureBuilder<void>(
      future: _controllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if(_image == null) {
            return _cameraBody();
          } else {
            return _previewBody();
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      }
    );
  }

  _selectCamera() {
    if (cameras.any(
      (element) =>
          element.lensDirection == _direction
    )) {
      _cameraIndex = cameras.indexOf(
        cameras.firstWhere((element) =>
            element.lensDirection == _direction),
      );
    } else {
      for (var i = 0; i < cameras.length; i++) {
        if (cameras[i].lensDirection == _direction) {
          _cameraIndex = i;
          break;
        }
      }
    }    
  }

  Future _init() async {
    final camera = cameras[_cameraIndex];
    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    _controllerFuture = _controller.initialize().then((_) {
      if(!mounted) {
        return;
      }
      setState(() {});
    });
  }

  Future _dispose() async {
    await _controller.dispose();
  }
  
  _switchCamera() async {
    if(cameras.length > 1) {
      _controller.dispose().then((value) => {
        setState(() {
          if(_direction == CameraLensDirection.front) {
            _direction = CameraLensDirection.back;
          } else {
            _direction = CameraLensDirection.front;
          }

          _selectCamera();
          _init();
        })
      });
    }
  }

  _takePicture() async {
    try {
      await _controllerFuture;

      final image = await _controller.takePicture();
      setState(() {
        _image = image;
      });

      if(!mounted) return;
    }
    catch(err) {
      // ignore: avoid_print
      print(err);
    }
  }

  _retake() {
    setState(() {
      _image = null;
    });
  }

  _next() {
    widget.onTakePicture(_image!.path);
  }

  Widget _cameraBody() {
    final size = MediaQuery.of(context).size;
    var scale = size.aspectRatio * _controller.value.aspectRatio;

    if(scale < 1) {
      scale = 1 / scale;
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Transform.scale(
          scale: scale,
          child: Center(
            child: CameraPreview(_controller),
          ),
        ),

        Positioned(
          bottom: 30,
          child: Container(
            alignment: Alignment.center,
            width: size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: size.width / 3,
                  child: TextButton(
                    onPressed: _switchCamera,
                    style: TextButton.styleFrom(
                      backgroundColor: LayoutColor.background,
                      foregroundColor: LayoutColor.textPrimary,
                      shape: const CircleBorder(),
                    ),
                    child: const Icon(
                      UniconsLine.refresh,
                      size: 30,
                    ),
                  ),
                ),
                SizedBox(
                  width: size.width / 3,
                  child: TextButton(
                    onPressed: _takePicture,
                    style: TextButton.styleFrom(
                      backgroundColor: LayoutColor.primary,
                      foregroundColor: LayoutColor.textPrimary,
                      shape: const CircleBorder(),
                    ),
                    child: const Icon(
                      Icons.camera,
                      size: 50,
                    ),
                  ),
                ),
                Container(
                  width: size.width / 3,
                ),
              ],
            ),
          )
        ),
      ],
    );
  }

  Widget _previewBody() {
    final size = MediaQuery.of(context).size;
    var scale = size.aspectRatio * _controller.value.aspectRatio;

    if(scale < 1) {
      scale = 1 / scale;
    }
    
    return Stack(
      fit: StackFit.expand,
      children: [
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(math.pi),
          child: Transform.scale(
            scale: scale,
            child: Center(
              child: Image.file(
                File(_image!.path),
              ),
            ),
          ),
        ),

        Positioned(
          bottom: 30,
          child: Container(
            alignment: Alignment.center,
            width: size.width,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: TextButton(
                    onPressed: _retake,
                    style: TextButton.styleFrom(
                      backgroundColor: LayoutColor.secondary,
                      foregroundColor: LayoutColor.background,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.restore),
                        SizedBox(width: 10),
                        Text('Foto Ulang'),
                      ]
                    ),
                  ),
                ),

                const SizedBox(
                  width: 20
                ),

                Flexible(
                  child: TextButton(
                    onPressed: _next,
                    style: TextButton.styleFrom(
                      backgroundColor: LayoutColor.primary,
                      foregroundColor: LayoutColor.textPrimary,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check),
                        SizedBox(width: 10),
                        Text('Lanjutkan'),
                      ]
                    ),
                  ),
                ),
              ],
            ),
          )
        ),
      ],
    );
  }
}