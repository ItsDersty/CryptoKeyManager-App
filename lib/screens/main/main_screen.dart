import 'package:cryptkey_manager_app/screens/main/welcome_screen.dart';
import 'package:flutter/material.dart';
//import 'package:cryptkey_manager_app/screens/main/welcome_screen.dart';
import 'package:cryptkey_manager_app/services/api_service.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final api = Provider.of<ApiService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('CryptKey Manager')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'auth status OK',
              style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(300, 50)),
              onPressed: () async {
                await api.signOut();
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const WelcomeScreen(),
                    ),
                    (route) => false,
                  );
                }
              },
              child: const Text('sign out'),
            ),
          ],
        ),
      ),
    );
  }
}
