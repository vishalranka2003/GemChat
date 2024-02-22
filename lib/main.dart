import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

void main() async {
  // Access your API key as an environment variable (see first step above)
  const apiKey = "AIzaSyDMqyS8qDt9MF257kfCJ-FjmhN5kdr1eWg";

  // For text-and-image input (multimodal), use the gemini-pro-vision model
  final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);

  const prompt = 'Write a story about a magic backpack.';
  final content = [Content.text(prompt)];
  final response = await model.generateContent(content);

  if (response.text != null) {
    runApp(MainApp(response.text!));
  } else {
    Fluttertoast.showToast(
      msg: 'Failed to generate content',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    exit(1);
  }
}

class MainApp extends StatelessWidget {
  final String generatedText;

  MainApp(this.generatedText);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Generated Content'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                generatedText,
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
