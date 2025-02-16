import 'package:contactsphere/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showAppAndDeveloperInfoDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20.r,
              backgroundImage: AssetImage("assets/img/splashicon.png"),
            ),
            SizedBox(width: 10.w),
            Text(
              'About ContactSphere',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Divider(),

              // App Info Section
              Text(
                'App Information',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 8.h),
              _infoRow(Icons.info, 'App Name: ContactSphere'),
              _infoRow(Icons.system_update, 'Version: 1.0.0'),
              _infoRow(Icons.description,
                  'Description: ContactSphere is a sleek and efficient Flutter-based contact manager, enabling seamless contact management with add, edit, delete, and favorite features for quick access. 🚀'),
              SizedBox(height: 16.h),

              // Developer Info Section
              Text(
                'Developer Information',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 8.h),
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40.r,
                      backgroundColor: Theme.of(context).primaryColor,
                      backgroundImage: NetworkImage(
                          "https://avatars.githubusercontent.com/u/118869302?v=4"),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'Naved Developer',
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4.h),
                    _infoRow(Icons.email, 'ansarinavedhabeeb@gmail.com'),
                    _infoRow(Icons.language, 'naveddeveloper.vercel.app'),
                    _infoRow(Icons.phone, '+91 9307147361'),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: TextStyle(fontSize: 16.sp),
            ),
          ),
        ],
      );
    },
  );
}

Widget _infoRow(IconData icon, String text) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 4.h),
    child: Row(
      children: [
        Icon(icon, size: 20, color: AppColorsDark.iconBackgroundColorPhone),
        SizedBox(width: 8.w),
        Expanded(child: Text(text, style: TextStyle(fontSize: 14.sp))),
      ],
    ),
  );
}
