import 'package:contactsphere/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Light Theme
final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    actionIconTheme: ActionIconThemeData(backButtonIconBuilder: (context) {
      return const Icon(
        Icons.arrow_back,
        color: Colors.black,
      );
    }),
    appBarTheme: AppBarTheme(
      toolbarHeight: 70.h,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20.r),
        ),
      ),
    ),
    bottomNavigationBarTheme:
        BottomNavigationBarThemeData(backgroundColor: AppColorsLight.barColor),
    colorScheme: ColorScheme.light(),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColorsLight.barColor,
      elevation: 2.0,
      surfaceTintColor: AppColorsLight.iconBackgroundColorPhone,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColorsLight.iconBackgroundColorPhone,
      foregroundColor: AppColorsLight.iconForegroundColorPhone,
      elevation: 2.0,
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: AppColorsLight.barColor,
    ),
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32.sp,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      headlineMedium: TextStyle(
        fontSize: 28.sp,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      headlineSmall: TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
      bodyLarge: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.normal,
        color: Colors.black87,
      ),
      bodyMedium: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.normal,
        color: Colors.black87,
      ),
      bodySmall: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.normal,
        color: Colors.black54,
      ),
      labelLarge: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        color: AppColorsLight.notfocusedBar,
      ),
      labelMedium: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.bold,
        color: AppColorsLight.notfocusedBar,
      ),
      labelSmall: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.bold,
        color: AppColorsLight.notfocusedBar,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
      foregroundColor:
          WidgetStatePropertyAll(AppColorsLight.iconForegroundColorPhone),
      backgroundColor:
          WidgetStatePropertyAll(AppColorsLight.iconBackgroundColorPhone),
    )),
    primaryColor: AppColorsLight.backgroundColor,
    cardColor: AppColorsLight.barColor,
    scaffoldBackgroundColor: AppColorsLight.backgroundColor,
    progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColorsLight.iconBackgroundColorPhone));

// Dark Theme
final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    actionIconTheme: ActionIconThemeData(backButtonIconBuilder: (context) {
      return const Icon(
        Icons.arrow_back,
        color: Colors.white,
      );
    }),
    appBarTheme: AppBarTheme(
      toolbarHeight: 70.h,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20.r),
        ),
      ),
    ),
    bottomNavigationBarTheme:
        BottomNavigationBarThemeData(backgroundColor: AppColorsDark.barColor),
    colorScheme: ColorScheme.dark(),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColorsDark.barColor,
      elevation: 2.0,
      surfaceTintColor: AppColorsDark.iconBackgroundColorPhone,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColorsDark.iconBackgroundColorPhone,
      foregroundColor: AppColorsDark.iconForegroundColorPhone,
      elevation: 2.0,
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: AppColorsDark.barColor,
    ),
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32.sp,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineMedium: TextStyle(
        fontSize: 28.sp,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      headlineSmall: TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.normal,
        color: Colors.white,
      ),
      bodyMedium: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.normal,
        color: Colors.white,
      ),
      bodySmall: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.normal,
        color: Colors.white,
      ),
      labelLarge: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
        color: AppColorsDark.notfocusedBar,
      ),
      labelMedium: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.bold,
        color: AppColorsDark.notfocusedBar,
      ),
      labelSmall: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.bold,
        color: AppColorsDark.notfocusedBar,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
      foregroundColor:
          WidgetStatePropertyAll(AppColorsDark.iconForegroundColorPhone),
      backgroundColor:
          WidgetStatePropertyAll(AppColorsDark.iconBackgroundColorPhone),
    )),
    primaryColor: AppColorsDark.backgroundColor,
    cardColor: AppColorsDark.barColor,
    scaffoldBackgroundColor: AppColorsDark.backgroundColor,
    progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColorsDark.iconForegroundColorPhone));
