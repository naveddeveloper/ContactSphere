import 'package:contactsphere/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomToast {
  static void show(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => ToastWidget(message: message),
    );

    overlay.insert(overlayEntry);

    // Remove the toast after 3 seconds with fade-out effect
    Future.delayed(Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }
}

class ToastWidget extends StatefulWidget {
  final String message;
  const ToastWidget({super.key, required this.message});

  @override
  State<ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      reverseDuration: Duration(milliseconds: 300),
    );
    _opacityAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();

    Future.delayed(Duration(seconds: 2), () {
      _controller.reverse();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OverlayEntryWidget(
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: EdgeInsets.only(bottom: 80.h),
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
            decoration: BoxDecoration(
              // Changed the color to green with opacity
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              widget.message,
              style: TextStyle(
                color: AppColorsLight.iconForegroundColorPhone,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class OverlayEntryWidget extends StatelessWidget {
  final Widget child;
  const OverlayEntryWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 80,
      left: MediaQuery.of(context).size.width * 0.15,
      width: MediaQuery.of(context).size.width * 0.7,
      child: child,
    );
  }
}