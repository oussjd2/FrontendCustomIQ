//import 'package:chatgpt_app_ui/utils/app_styles.dart';
//import 'package:chatgpt_app_ui/utils/responsive.dart';
import 'package:flutter/material.dart';

import '../utils/app_styles.dart';
import '../utils/data.dart';
import '../utils/responsive.dart';
import '../widgets/getting_started_tips_builder.dart';
import '../widgets/input_field.dart';
import '../widgets/message_bubble.dart';

class Chat extends StatefulWidget {
  final String name;

  const Chat({super.key, required this.name});

  //const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  bool showSteps = true;

  void _toggleSteps() {
    setState(() {
      showSteps = !showSteps;
    });
  }
  List<String> conversationList = [
    'Creating Flutter App',
    'Debug Error ',
    'Type Mismatch',

  ];
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: cWhite,
      appBar: _buildChatScreenAppBar(_toggleSteps),
      endDrawer:ChatHistoryDrawer(conversations :this.conversationList,name: widget.name,),
      body: Stack(children: [
        SizedBox(height: SizeConfig.horizontalBlockSize! * 2),
        const Divider(
          color: cGrey,
          thickness: 1,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.horizontalBlockSize! * 3,
              vertical: SizeConfig.verticalBlockSize! * 3),
          //main content goes here

          child: showSteps
              ? const GettingStartedTipsBuilder()
              : ListView.builder(
                  itemCount: chatMessages.length,
                  itemBuilder: (context, index) {
                    return MessageBubble(
                      message: chatMessages[index]["message"].toString(),
                      isMe: chatMessages[index]["isMe"],
                    );
                  },
                ),
        ),
        const InputField()
      ]),
    );
  }

  AppBar _buildChatScreenAppBar(Function toggleSteps) {
    return AppBar(
      //elevation: 0,
      //backgroundColor: cWhite,
      title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /*IconButton(
                onPressed: _toggleSteps,
                icon: const Icon(
                  Icons.arrow_back,
                  color: cBlack,
                )),*/
            Image.asset('assets/avatar.png'),
            SizedBox(width: SizeConfig.horizontalBlockSize! * 3),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(widget.name,
                  style: cBold.copyWith(
                    color: cPrimaryBlue,
                    fontSize: 20,
                  )),
              Text('Online',
                  style: cSemiBold.copyWith(
                    color: cGreen,
                    fontSize: 18,
                  )),
            ]),
            /*const Spacer(),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.volume_up,
                  color: cBlack,
                )),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.exit_to_app,
                  color: cGrey,
                )),*/
          ]),
    );
  }
}
class ChatHistoryDrawer extends StatelessWidget {
  final List<String> conversations;
  final String name;
  ChatHistoryDrawer({required this.conversations, required this.name});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(name),
            accountEmail: null,
            currentAccountPicture: CircleAvatar(
                radius: 60,// Circular icon
                backgroundImage: AssetImage('assets/user_profile.jpg') // Replace with user's image URL
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(conversations[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete_outline),
                    onPressed: () {

                    },
                  ),
                  onTap: () {

                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
