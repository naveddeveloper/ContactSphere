import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showPopupDialog(BuildContext context, String title, String desc,
    VoidCallback cancel, VoidCallback success) {
  showDialog(
    context: context,
    barrierDismissible: false, // Allows tapping outside to close the dialog
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title, style: TextStyle(
          fontSize: 24.sp
        )),
        content: Text(desc, style: TextStyle(
          fontSize: 16.sp
        )),
        actions: [
          TextButton(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.red.shade400),
              foregroundColor: WidgetStatePropertyAll(const Color.fromARGB(255, 90, 14, 14))
            ),
            onPressed: cancel,
            child: Text('Cancel', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: success,
            child: Text('Confirm', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold))
          ),
        ],
      );
    },
  );
}
