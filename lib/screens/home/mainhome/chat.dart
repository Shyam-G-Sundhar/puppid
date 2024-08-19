import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class MessageChat extends StatefulWidget {
  const MessageChat({Key? key}) : super(key: key);

  @override
  _MessageChatState createState() => _MessageChatState();
}

class _MessageChatState extends State<MessageChat> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();

    _messages.add(ChatMessage(
        textcolor: Colors.white,
        iconColor: Colors.white,
        timeColor: Colors.white,
        profileColor: Colors.white,
        sender: 'Me',
        text: 'Hi',
        color: Colors.green,
        isUser: true,
        timestamp: DateTime.now()));

    _messages.add(ChatMessage(
        textcolor: Colors.black,
        iconColor: Colors.black,
        timeColor: Colors.black,
        profileColor: Colors.black,
        sender: 'Mr. User',
        text: 'Hello! How can I assist you?',
        color: Colors.black12,
        isUser: false,
        timestamp: DateTime.now()));
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 25,
              ),
            ),
          ),
          backgroundColor: Colors.green,
          toolbarHeight: 65,
          elevation: 10,
          title: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Image.asset('assets/paw.png'),
                ),
              ),
              SizedBox(width: 15),
              Text(
                'Name',
                style: GoogleFonts.robotoFlex(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return ChatMessageWidget(message: _messages[index]);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: GoogleFonts.robotoFlex(),
                        helperStyle: GoogleFonts.robotoFlex(),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.green, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.green, width: 2.0),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Colors.green,
                    ),
                    onPressed: () {
                      _sendMessage();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    if (_textController.text.isNotEmpty) {
      setState(() {
        _messages.add(ChatMessage(
            iconColor: Colors.white,
            timeColor: Colors.white,
            profileColor: Colors.white,
            sender: 'User',
            textcolor: Colors.white,
            text: _textController.text,
            color: Colors.green,
            isUser: true,
            timestamp: DateTime.now()));

        _messages.add(ChatMessage(
            iconColor: Colors.black,
            timeColor: Colors.black,
            profileColor: Colors.black,
            textcolor: Colors.black,
            sender: 'Mr. User',
            text: 'I received your message',
            color: Colors.black12,
            isUser: false,
            timestamp: DateTime.now()));
        _textController.clear();
      });
    }
  }
}

class ChatMessage {
  final String sender;
  final String text;
  final Color color;
  final Color textcolor;
  final Color profileColor;
  final Color iconColor;
  final Color timeColor;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage(
      {required this.sender,
      required this.text,
      required this.iconColor,
      required this.profileColor,
      required this.timeColor,
      required this.textcolor,
      this.color = Colors.grey,
      this.isUser = false,
      required this.timestamp});
}

class ChatMessageWidget extends StatelessWidget {
  final ChatMessage message;

  ChatMessageWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: message.isUser
              ? [Colors.green, Colors.lightGreen]
              : [Colors.white, Colors.grey[300]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (message.isUser)
                Icon(Icons.account_circle, color: message.profileColor),
              if (!message.isUser)
                Icon(Icons.pets, color: message.profileColor),
              SizedBox(width: 10),
              Text(
                message.sender,
                style: GoogleFonts.robotoFlex(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: message.profileColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Text(
            message.text,
            style: GoogleFonts.robotoFlex(
                fontSize: 17,
                color: message.textcolor,
                fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 8.0),
          Text(
            DateFormat('hh:mm a').format(message.timestamp),
            style: GoogleFonts.robotoFlex(
                fontSize: 12,
                color: message.timeColor,
                fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
