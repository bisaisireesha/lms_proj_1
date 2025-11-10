import 'package:flutter/material.dart';
import '../models/checkpoint.dart';

class CheckpointDialog extends StatefulWidget {
  final Checkpoint checkpoint;
  final Function(int selectedAnswer) onAnswerSelected;

  const CheckpointDialog({
    Key? key,
    required this.checkpoint,
    required this.onAnswerSelected,
  }) : super(key: key);

  @override
  _CheckpointDialogState createState() => _CheckpointDialogState();
}

class _CheckpointDialogState extends State<CheckpointDialog> {
  int? selectedAnswer;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(Icons.quiz, color: Colors.blue, size: 32),
                SizedBox(width: 12),
                Text(
                  'Checkpoint Question',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              widget.checkpoint.question,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Column(
              children: widget.checkpoint.choices.asMap().entries.map((entry) {
                int index = entry.key;
                String choice = entry.value;
                return Container(
                  margin: EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedAnswer = index;
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selectedAnswer == index
                              ? Colors.blue
                              : Colors.grey.shade300,
                          width: selectedAnswer == index ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        color: selectedAnswer == index
                            ? Colors.blue.shade50
                            : Colors.white,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: selectedAnswer == index
                                    ? Colors.blue
                                    : Colors.grey.shade400,
                              ),
                              color: selectedAnswer == index
                                  ? Colors.blue
                                  : Colors.white,
                            ),
                            child: selectedAnswer == index
                                ? Icon(Icons.check, size: 16, color: Colors.white)
                                : null,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              choice,
                              style: TextStyle(
                                fontSize: 14,
                                color: selectedAnswer == index
                                    ? Colors.blue.shade800
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: selectedAnswer != null
                      ? () {
                          widget.onAnswerSelected(selectedAnswer!);
                          Navigator.of(context).pop();
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Submit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}