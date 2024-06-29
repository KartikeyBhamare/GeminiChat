import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

import 'package:geminichatapp/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final Gemini gemini = Gemini.instance;
  ChatUser currentUser = ChatUser(id: '0', firstName: 'User');
  ChatUser geminiUser = ChatUser(
      id: '1',
      firstName: 'Gemini',
      profileImage:
          'https://uxwing.com/wp-content/themes/uxwing/download/brands-and-social-media/google-gemini-icon.png');
  List<ChatMessage> messages = [];
  bool showWelcomeMessage = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    Provider.of<ThemeProvider>(context, listen: false).updateThemeFromSystem();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    var themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: ImageIcon(
            color: isDarkMode ? Colors.grey.shade500 : Colors.grey.shade800,
            const AssetImage(
              'assets/google-gemini-icon.png',
            ),
          ),
        ),
        leadingWidth: 40,
        title: const Center(
          child: Text(
            'Gemini',
            style: TextStyle(fontFamily: 'Raleway'),
          ),
        ),
        actions: [
          Transform.scale(
            scale: 0.75,
            child: Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Switch(
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  themeProvider.toggleTheme();
                },
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          _buildChat(),
          if (showWelcomeMessage) _buildWelcomeMessage(),
        ],
      ),
    );
  }

  Widget _buildChat() {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    return DashChat(
      currentUser: currentUser,
      onSend: _sendMessage,
      messages: messages,
      messageOptions: MessageOptions(
        messageTextBuilder: (ChatMessage message, ChatMessage? previousMessage,
            ChatMessage? nextMessage) {
          if (message.user.id == currentUser.id) {
            return Text(
              message.text,
              style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 16.0,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            );
          } else {
            return GestureDetector(
              onTap: () {
                _copyMessageText(message.text);
              },
              child: Text(
                message.text,
                style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 16.0,
                  color: isDarkMode ? Colors.white : Colors.white,
                ),
              ),
            );
          }
        },
        messageDecorationBuilder: (ChatMessage message,
            ChatMessage? previousMessage, ChatMessage? nextMessage) {
          if (message.user.id == geminiUser.id) {
            return BoxDecoration(
              color: Colors.blue.shade600,
              borderRadius: BorderRadius.circular(16.0),
            );
          }
          return BoxDecoration(
            color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(16.0),
          );
        },
      ),
      inputOptions: InputOptions(
        sendButtonBuilder: (onSend) {
          return GestureDetector(
            onTap: onSend,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.send,
                color: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade500,
              ),
            ),
          );
        },
        inputDecoration: InputDecoration(
          hintText: 'Type your message...',
          hintStyle: TextStyle(
            fontFamily: 'Raleway',
            color: isDarkMode ? Colors.grey.shade300 : Colors.grey.shade900,
          ),
          filled: true,
          fillColor: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        ),
      ),
    );
  }

  void _copyMessageText(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Message copied to clipboard'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  Widget _buildWelcomeMessage() {
    return Center(
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        opacity: showWelcomeMessage ? 1.0 : 0.0,
        child: const Text(
          'Hello! 👋 Start chatting...',
          style: TextStyle(fontFamily: 'Raleway', fontSize: 25.0),
        ),
      ),
    );
  }

  Future<void> _sendMessage(ChatMessage chatMessage) async {
    setState(() {
      messages = [chatMessage, ...messages];
      showWelcomeMessage = false;
    });

    try {
      String question = chatMessage.text;
      gemini.streamGenerateContent(question).listen((event) {
        ChatMessage? lastMessage = messages.isNotEmpty ? messages.first : null;
        if (lastMessage != null && lastMessage.user == geminiUser) {
          String response = event.content?.parts?.fold(
                  "", (previous, current) => "$previous ${current.text}") ??
              "";
          setState(() {
            lastMessage.text += response;
          });
        } else {
          String response = event.content?.parts?.fold(
                  "", (previous, current) => "$previous ${current.text}") ??
              "";
          ChatMessage responseMessage = ChatMessage(
              user: geminiUser, createdAt: DateTime.now(), text: response);
          setState(() {
            messages = [responseMessage, ...messages];
          });
        }
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }
}
