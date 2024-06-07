import'package:flutter/material.dart';
import 'my_button.dart';

class DialogBox extends StatelessWidget {
  final controller;
  VoidCallback onSave;
  VoidCallback onCancel;

  DialogBox({
    super.key,
    required this.controller,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.purple.shade100,
      content: Container(
        height: 120,
        child:  Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4))
                
                ),
              hintText : "Add a new task",
              ),
          
            ),
            const Padding(padding: EdgeInsets.only(bottom: 15)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                MyButton(text: "Save" , onPressed: onSave),
                const SizedBox(width: 8),
                MyButton(text: "Cancel", onPressed: onCancel),
              ],
            )
          ],
        )
      ),
    );
  }
}