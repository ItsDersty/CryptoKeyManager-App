import 'package:cryptkey_manager_app/screens/auth/auth_screen.dart';
import 'package:cryptkey_manager_app/screens/auth/login_screen.dart';
import 'package:cryptkey_manager_app/screens/main/main_screen.dart';
import 'package:cryptkey_manager_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:cryptkey_manager_app/screens/main/welcome_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(Provider(create: (_) => ApiService(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CryptKey Manager',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),

        menuTheme: MenuThemeData(
          style: MenuStyle(
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            ),
          ),
        ),
      ),
      home: AuthWrapper(),

      routes: {
        '/welcome': (context) => WelcomeScreen(),
        '/home': (context) => MainScreen(),
        '/auth': (context) => AuthScreen(),
        '/auth/login': (context) => LoginScreen(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final api = Provider.of<ApiService>(context, listen: false);

    return FutureBuilder<String?>(
      future: api.storage.read(key: 'access_token'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          return const MainScreen();
        } else {
          return const WelcomeScreen();
        }
      },
    );
  }
}
