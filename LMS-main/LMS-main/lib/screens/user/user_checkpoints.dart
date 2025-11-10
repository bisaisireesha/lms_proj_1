import 'package:flutter/material.dart';
import '../../models/checkpoint.dart';

class CheckpointPage extends StatelessWidget {
  final Checkpoint checkpoint;
  final void Function(int selectedAnswer) onAnswerSelected;

  const CheckpointPage({
    Key? key,
    required this.checkpoint,
    required this.onAnswerSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkpoint'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              checkpoint.question,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ...List.generate(checkpoint.choices.length, (index) {
              return ListTile(
                title: Text(
                  checkpoint.choices[index],
                  style: const TextStyle(fontSize: 16),
                ),
                leading: Radio<int>(
                  value: index,
                  groupValue: null,
                  onChanged: (val) {
                    if (val != null) {
                      onAnswerSelected(val);
                      Navigator.pop(context);
                    }
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
