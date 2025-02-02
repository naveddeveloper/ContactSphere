import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:contactsphere/providers/theme_provider.dart';
import 'package:contactsphere/screens/contact_screen.dart';
import 'package:contactsphere/screens/favorite_screen.dart';
import 'package:contactsphere/styles/colors.dart';
import 'package:contactsphere/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:contactsphere/providers/contact_provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ContactProvider()),
      ChangeNotifierProvider(create: (context) => ThemeProvider())
    ],
    child: const ContactApp(),
  ));
}

class ContactApp extends StatelessWidget {
  const ContactApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, child) {
            return MaterialApp(
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: themeProvider.themeMode,
              debugShowCheckedModeBanner: false,
              home: const SplashScreen(),
            );
          },
        );
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 3000,
      splash: Center(child: Image.asset("assets/img/splashicon.png")),
      nextScreen: const MainScreen(),
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor: Theme.of(context).primaryColor,
      splashIconSize: 200,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = [
    const FavoriteScreen(),
    const ContactScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    Brightness brightness = Theme.of(context).brightness;

    return Scaffold(
      body: Consumer<ContactProvider>(
        builder: (context, contactProvider, child) {
          return _widgetOptions[_selectedIndex];
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        
        selectedItemColor:
            brightness == Brightness.dark ? Colors.white : Colors.black,
        unselectedItemColor:
            brightness == Brightness.dark ? Colors.grey[300] : Colors.grey[800],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: _buildNavItem(Icons.favorite, 0, brightness),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: _buildNavItem(Icons.person, 1, brightness),
            label: 'Contacts',
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index, Brightness brightness) {
    return Container(
      decoration: BoxDecoration(
        color: _selectedIndex == index
            ? (brightness == Brightness.dark
                ? AppColorsDark.iconBackgroundColorPhone
                : AppColorsLight.iconBackgroundColorPhone)
            : Colors.transparent,
        shape: BoxShape.circle,
      ),
      padding: const EdgeInsets.all(8),
      child: Icon(
        icon,
        color: brightness == Brightness.dark ? Colors.white : Colors.black,
      ),
    );
  }

}
