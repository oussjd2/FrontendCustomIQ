import 'dart:async';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:avatarmakercopy/const.dart';
import 'CameraAnalysisScreen.dart';  // Ensure the correct import path for CameraAnalysisScreen

class ChatPage extends StatefulWidget {
  final String modelUrl;

  const ChatPage({Key? key, required this.modelUrl}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _openAI = OpenAI.instance.build(
    token: OPENAI_API_KEY,
    baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 5)),
    enableLog: true,
  );

  final FlutterTts flutterTts = FlutterTts();
  bool _isTtsEnabled = true;

  final ChatUser _currentUser = ChatUser(id: '1', firstName: 'Oussama', lastName: 'Jaouadi');
  final ChatUser _gptChatUser = ChatUser(id: '2', firstName: 'Chat', lastName: 'GPT');

  List<ChatMessage> _messages = <ChatMessage>[];
  List<ChatUser> _typingUsers = <ChatUser>[];

  // Categories and predefined prompts
  final List<String> categories = ["prompt generator", "Chess Player", "Financial Analyst", "UX/UI Developer", "Interviewer"];
  String selectedCategory = "prompt generator";
  Map<String, String> categoryPrompts = {
    "prompt generator": "I want you to act as a ChatGPT prompt generator, I will send a topic, you have to generate a ChatGPT prompt based on the content of the topic, the prompt should start with 'I want you to act as '', and guess what I might do, and expand the prompt accordingly Describe the content to make it useful.",
    "Chess Player": "I want you to act as a rival chess player. I We will say our moves in reciprocal order. In the beginning I will be white. Also please don't explain your moves to me because we are rivals. After my first message i will just write my move. Don't forget to update the state of the board in your mind as we make moves. My first move is e4.",
    "Financial Analyst": "Want assistance provided by qualified individuals enabled with experience on understanding charts using technical analysis tools while interpreting macroeconomic environment prevailing across world consequently assisting customers acquire long term advantages requires clear verdicts therefore seeking same through informed predictions written down precisely! First statement contains following content- “Can you tell us what future stock market looks like based upon current conditions ?",
    "UX/UI Developer": "I want you to act as a UX/UI developer. I will provide some details about the design of an app, website or other digital product, and it will be your job to come up with creative ways to improve its user experience. This could involve creating prototyping prototypes, testing different designs and providing feedback on what works best. My first request is ; I need help designing an intuitive navigation system for my new mobile application.",
    "Interviewer": "I want you to act as an interviewer.I want you to only reply as the interviewer. Do not write all the conservation at once. I want you to only do the interview with me. Ask me [precise] questions and wait for my answers. Do not write explanations. Ask me questions one by one like a [human] interviewer does and wait for my answers."
  };

  @override
  void initState() {
    super.initState();
    initTts();
  }

  void initTts() {
    flutterTts.setStartHandler(() {
      print("Playback started");
    });
    flutterTts.setCompletionHandler(() {
      print("Playback completed");
    });
    flutterTts.setErrorHandler((msg) {
      print("Playback error: $msg");
    });
    flutterTts.setSpeechRate(0.5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 166, 126, 1),
        title: const Text('CustomIQ', style: TextStyle(color: Colors.white)),
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedCategory,
              dropdownColor: Colors.blue,
              items: categories.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: TextStyle(color: Colors.white)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedCategory = value;
                  });
                  sendInitialPrompt(categoryPrompts[value]!);
                }
              },
              icon: Icon(Icons.arrow_drop_down, color: Colors.white),
            ),
          ),
          IconButton(
            icon: Icon(_isTtsEnabled ? Icons.volume_up : Icons.volume_off),
            onPressed: () => setState(() => _isTtsEnabled = !_isTtsEnabled),
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CameraAnalysisScreen())),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 150,
            child: ModelViewer(
              src: widget.modelUrl,
              alt: "A 3D model",
              ar: true,
              autoRotate: true,
              cameraControls: true,
            ),
          ),
          Expanded(
            child: DashChat(
              currentUser: _currentUser,
              typingUsers: _typingUsers,
              messageOptions: const MessageOptions(
                currentUserContainerColor: Colors.black,
                containerColor: Color.fromRGBO(0, 166, 126, 1),
                textColor: Colors.white,
              ),
              onSend: getChatResponse,
              messages: _messages,
            ),
          ),
        ],
      ),
    );
  }

  // Sends the initial category-specific prompt to the model
  void sendInitialPrompt(String prompt) async {
    final request = ChatCompleteText(
      model: GptTurbo0301ChatModel(),
      messages: [Messages(role: Role.user, content: prompt)],
      maxToken: 200,
    );
    final response = await _openAI.onChatCompletion(request: request);
    if (response!.choices.isNotEmpty && response.choices.first.message != null) {
      setState(() {
        _messages.insert(0, ChatMessage(
            user: _gptChatUser,
            createdAt: DateTime.now(),
            text: response!.choices.first.message!.content
        ));
        if (_isTtsEnabled) {
          flutterTts.speak(response.choices.first.message!.content);
        }
      });
    }
  }

  Future<void> getChatResponse(ChatMessage m) async {
    setState(() {
      _messages.insert(0, m);
      _typingUsers.add(_gptChatUser);
    });
    List<Messages> messagesHistory = _messages.reversed.map((m) {
      return Messages(role: m.user == _currentUser ? Role.user : Role.assistant, content: m.text);
    }).toList();

    final request = ChatCompleteText(
      model: GptTurbo0301ChatModel(),
      messages: messagesHistory,
      maxToken: 200,
    );

    try {
      final response = await _openAI.onChatCompletion(request: request);
      for (var element in response!.choices) {
        if (element.message != null) {
          setState(() {
            _messages.insert(0, ChatMessage(
                user: _gptChatUser,
                createdAt: DateTime.now(),
                text: element.message!.content
            ));
            if (_isTtsEnabled) {
              flutterTts.speak(element.message!.content);
            }
          });
        }
      }
    } catch (e) {
      print("An unexpected error occurred: $e");
    } finally {
      setState(() {
        _typingUsers.remove(_gptChatUser);
      });
    }
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }
}
