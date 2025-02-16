import 'package:contactsphere/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputBar extends StatelessWidget {
  final String labelStr;
  final TextInputType inputType;
  final TextEditingController? controller; 
  final String? Function(String?)? validator; 

  const InputBar({
    super.key,
    required this.labelStr,
    required this.inputType,
    this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;

    return Padding(
      padding: EdgeInsets.all(8.0.h),
      child: TextFormField(
        style: TextStyle(
          fontSize: 16.sp
        ),
        cursorColor: AppColorsLight.iconForegroundColorPhone,
        controller: controller,
        keyboardType: inputType,
        keyboardAppearance: brightness,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0.r),
            borderSide: BorderSide.none,
          ),
          hintText: labelStr,
          filled: true,
          fillColor: Theme.of(context).cardColor,
        ),
        validator: validator, // Optional validation
      ),
    );
  }
}
