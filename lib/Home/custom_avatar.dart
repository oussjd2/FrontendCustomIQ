import 'package:flutter/material.dart';

import 'CustumizeAvatar.dart';

class AvatarGeneratorPage extends StatefulWidget {
  @override
  _AvatarGeneratorPageState createState() => _AvatarGeneratorPageState();
}

class _AvatarGeneratorPageState extends State<AvatarGeneratorPage> {
  TextEditingController _textFieldController = TextEditingController();
  String _avatarImageUrl = ''; // You can set a default image URL here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate Avatar'),

        actions: [
          CircleAvatar(
              radius: 20,// Circular icon
              backgroundImage: AssetImage('assets/user_profile.jpg') // Replace with user's image URL
          ),
          SizedBox(width: 8,)
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Generate Your Avatar',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            CircleAvatar(
              radius: 100,
              backgroundImage:AssetImage('assets/user_profile.jpg'), // Placeholder image asset
            ),
            SizedBox(height: 10.0),
            SizedBox(
              width: double.infinity,
              height: 50.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.grey),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextField(
                    controller: _textFieldController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter your name',
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            SizedBox(
              width: double.infinity,
              height: 50.0,
              child: ElevatedButton(
                onPressed: () {
                  //String name = _textFieldController.text;
                 Navigator.push(context, MaterialPageRoute(builder: (conext)=> CustomizeAvatarPage()));
                },
                child: Text(
                  'Generate Your Avatar',
                  style: TextStyle(fontSize: 16.0),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to generate avatar image URL based on the name
  String _generateAvatarImageUrl(String name) {
    // You can use any avatar generation service or algorithm here
    // For demonstration, let's assume a simple URL format
    return 'https://avatar-service.com/$name/avatar.jpg';
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }
}

