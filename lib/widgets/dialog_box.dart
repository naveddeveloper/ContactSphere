import 'package:flutter/material.dart';

void showPopupDialog(BuildContext context, String title, String desc,
    VoidCallback cancel, VoidCallback success) {
  showDialog(
    context: context,
    barrierDismissible: false, // Allows tapping outside to close the dialog
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(desc),
        actions: [
          TextButton(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.red.shade400),
              foregroundColor: WidgetStatePropertyAll(const Color.fromARGB(255, 90, 14, 14))
            ),
            onPressed: cancel,
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: success,
            child: Text('Confirm'),
          ),
        ],
      );
    },
  );
}
