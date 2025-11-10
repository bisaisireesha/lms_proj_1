import 'package:flutter/material.dart';

class QuizQuestionScreen extends StatefulWidget {
  final String question;
  final List<String> choices;
  final Function(String) onAnswerSelected;

  QuizQuestionScreen({
    required this.question,
    required this.choices,
    required this.onAnswerSelected,
  });

  @override
  _QuizQuestionScreenState createState() => _QuizQuestionScreenState();
}

class _QuizQuestionScreenState extends State<QuizQuestionScreen> {
  String? selectedChoice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quiz')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(widget.question, style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            ...widget.choices.map((choice) => ListTile(
                  title: Text(choice),
                  leading: Radio<String>(
                    value: choice,
                    groupValue: selectedChoice,
                    onChanged: (value) {
                      setState(() {
                        selectedChoice = value;
                      });
                      widget.onAnswerSelected(value!);
                    },
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
