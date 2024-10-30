import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:file_picker/file_picker.dart';

import 'AdvancedSettingsScreen.dart';
import 'Chat_Page.dart';  // Ensure this is the correct import for your ChatPage

class DisplayModelScreen extends StatefulWidget {
  @override
  _DisplayModelScreenState createState() => _DisplayModelScreenState();
}

class _DisplayModelScreenState extends State<DisplayModelScreen> {
  final TextEditingController _urlController = TextEditingController();
  String? _modelUrl;

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _loadModelFromUrl() {
    setState(() {
      _modelUrl = _urlController.text;
    });
  }

  void _removeModel() {
    setState(() {
      _modelUrl = null;
    });
  }

  Future<void> _pickAndLoadModel() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null) {
      setState(() {
        _modelUrl = result.files.single.path;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No file selected')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isModelLoaded = _modelUrl != null;
    return Scaffold(
      appBar: AppBar(
        title: Text("Load and Display 3D Model"),
        backgroundColor: Colors.lightBlue[300], // Light blue color for the AppBar
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: "Enter GLB URL",
                border: OutlineInputBorder(),
                fillColor: Colors.lightBlue[50], // Light blue color for the TextField
                filled: true,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _loadModelFromUrl,
            child: Text("Load Model from URL"),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.lightBlue,
            ),
          ),
          ElevatedButton(
            onPressed: _pickAndLoadModel,
            child: Text("Load Model from Device"),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.lightBlue,
            ),
          ),
          ElevatedButton(
            onPressed: isModelLoaded ? () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatPage(modelUrl: _modelUrl!)),  // Pass the model URL to ChatPage
              );
            } : null,
            child: Text("Chat with CustomIQ"),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.lightBlue,
              disabledBackgroundColor: Colors.grey,
              disabledForegroundColor: Colors.white,
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdvancedSettingsScreen()),
              );
              if (result != null) {
                _urlController.text = "${_urlController.text}$result";
                _loadModelFromUrl();
              }
            },
            child: Text("Advanced"),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.lightBlue,
            ),
          ),
          if (isModelLoaded) ...[
            ElevatedButton(
              onPressed: _removeModel,
              child: Text("Remove Model"),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.red,
              ),
            ),
            Expanded(
                child: ModelViewer(
                  src: _modelUrl!,
                  alt: "A 3D model",
                  ar: true,
                  autoRotate: true,
                  cameraControls: true,
                )
            ),
          ] else ...[
            Expanded(
              child: Center(
                child: Text("No model URL provided or model removed"),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
