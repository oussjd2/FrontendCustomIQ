import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';

class CameraAnalysisScreen extends StatefulWidget {
  @override
  _CameraAnalysisScreenState createState() => _CameraAnalysisScreenState();
}

class _CameraAnalysisScreenState extends State<CameraAnalysisScreen> {
  CameraController? _controller;
  String? _imagePath;
  final List<DetectedObject> _detectedObjects = [];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  void _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      _controller = CameraController(cameras[0], ResolutionPreset.medium);
      await _controller!.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    }
  }

  void performObjectDetection(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final objectDetector = ObjectDetector(options: ObjectDetectorOptions(
        classifyObjects: true,
        multipleObjects: true,
        mode: DetectionMode.stream
    ));
    try {
      final objects = await objectDetector.processImage(inputImage);
      setState(() {
        _detectedObjects.clear();
        _detectedObjects.addAll(objects);
      });
    } catch (e) {
      print('Error occurred while detecting objects: $e');
    }
    objectDetector.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Capture and Analyze"),
      ),
      body: _controller == null || !_controller!.value.isInitialized
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: CameraPreview(_controller!),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _imagePath == null
                ? ElevatedButton(
              onPressed: () async {
                try {
                  final image = await _controller!.takePicture();
                  setState(() {
                    _imagePath = image.path;
                  });
                  performObjectDetection(image.path);
                } catch (e) {
                  print("Error taking picture: $e");
                }
              },
              child: Text("Capture Image"),
            )
                : Column(
              children: [
                Image.file(File(_imagePath!)),
                Text('Detected Objects: ${_detectedObjects.length}'),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _detectedObjects.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('Object ${index + 1}'),
                      subtitle: Text('Confidence: ${_detectedObjects[index].labels.first.confidence.toStringAsFixed(2)}'),
                    );
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _imagePath = null;
                      _detectedObjects.clear();
                    });
                  },
                  child: Text("Capture New Image"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
