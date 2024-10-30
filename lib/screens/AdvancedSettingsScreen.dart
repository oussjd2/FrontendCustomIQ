import 'package:flutter/material.dart';

class AdvancedSettingsScreen extends StatefulWidget {
  @override
  _AdvancedSettingsScreenState createState() => _AdvancedSettingsScreenState();
}

class _AdvancedSettingsScreenState extends State<AdvancedSettingsScreen> {
  String _quality = 'high';
  String _textureQuality = 'high';
  String _pose = 'A';
  String _textureSizeLimit = '1024';
  String _textureFormat = 'png';

  void _applySettings() {
    String params = "?quality=$_quality&textureQuality=$_textureQuality&pose=$_pose"
        "&textureSizeLimit=$_textureSizeLimit&textureFormat=$_textureFormat";
    Navigator.pop(context, params);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Advanced Settings"),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<String>(
            value: _quality,
            decoration: InputDecoration(labelText: "Model Quality"),
            items: ['low', 'medium', 'high'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _quality = newValue!;
              });
            },
          ),
          DropdownButtonFormField<String>(
            value: _textureQuality,
            decoration: InputDecoration(labelText: "Texture Quality"),
            items: ['low', 'medium', 'high'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _textureQuality = newValue!;
              });
            },
          ),
          DropdownButtonFormField<String>(
            value: _pose,
            decoration: InputDecoration(labelText: "Model Pose"),
            items: ['A', 'T'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _pose = newValue!;
              });
            },
          ),
          DropdownButtonFormField<String>(
            value: _textureSizeLimit,
            decoration: InputDecoration(labelText: "Texture Size Limit"),
            items: ['256', '512', '1024'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _textureSizeLimit = newValue!;
              });
            },
          ),
          DropdownButtonFormField<String>(
            value: _textureFormat,
            decoration: InputDecoration(labelText: "Texture Format"),
            items: ['webp', 'jpeg', 'png'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _textureFormat = newValue!;
              });
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _applySettings,
            child: Text('Apply Settings'),
          ),
        ],
      ),
    );
  }
}
