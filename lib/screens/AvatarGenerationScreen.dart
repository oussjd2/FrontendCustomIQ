import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AvatarGenerationScreen extends StatefulWidget {
  final String userId; // Assuming you pass the userId of the newly registered user

  const AvatarGenerationScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _AvatarGenerationScreenState createState() => _AvatarGenerationScreenState();
}

class _AvatarGenerationScreenState extends State<AvatarGenerationScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  String _avatarUrl = ''; // To store the URL of the generated avatar

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _generateAvatar() async {
    final apiService = Provider.of<ApiService>(context, listen: false);
    try {
      final avatarUrl = await apiService.generateAvatar(_descriptionController.text);
      setState(() {
        _avatarUrl = avatarUrl;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to generate avatar: $e')));
    }
  }

  void _saveAvatar() async {
    final apiService = Provider.of<ApiService>(context, listen: false);
    try {
      await apiService.saveAvatarForUser(widget.userId, _avatarUrl);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Avatar saved successfully')));
      // Navigate to user details or home screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save avatar: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Avatar'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Describe your avatar'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _generateAvatar,
                child: const Text('Generate Avatar'),
              ),
              if (_avatarUrl.isNotEmpty)
                Column(
                  children: [
                    Image.network(_avatarUrl, height: 150),
                    ElevatedButton(
                      onPressed: _saveAvatar,
                      child: const Text('Save Avatar'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
