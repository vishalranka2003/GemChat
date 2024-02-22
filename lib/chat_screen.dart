import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'api/api_key.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final List<String> chatMessages = [];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Material(
        child: Column(
          children: [
            // Chat display area
            Expanded(
              child: ListView.builder(
                itemCount: chatMessages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(chatMessages[index]),
                  );
                },
              ),
            ),
            // Input box at the bottom
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textEditingController,
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      // Handle sending the message
                      String message = _textEditingController.text;
                      // Add the message to the chat display
                      setState(() {
                        chatMessages.add('You: $message');
                        isLoading = true; // Show loader
                      });
                      // Call the API and generate a response
                      _generateResponse(message);
                      // Clear the text field after sending the message
                      _textEditingController.clear();
                    },
                  ),
                ],
              ),
            ),
            // Loader
            if (isLoading) CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  Future<void> _generateResponse(String prompt) async {
    final key = apiKey;

    try {
      final model = GenerativeModel(model: 'gemini-pro', apiKey: key);
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      if (response.text != null) {
        setState(() {
          chatMessages.add('AI: ${response.text}');
        });
      } else {
        _showErrorToast();
      }
    } catch (e) {
      _showErrorToast();
    } finally {
      setState(() {
        isLoading = false; // Hide loader
      });
    }
  }

  void _showErrorToast() {
    Fluttertoast.showToast(
      msg: 'Failed to generate content',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
