import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Sign up",
              style: Theme.of(context).textTheme.displayMedium,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: 300,

              child: TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email_rounded),
                ),
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: 300,
              child: TextField(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  labelText: "Password",
                  prefixIcon: Icon(Icons.password_rounded),
                ),
              ),
            ),

            SizedBox(
              width: 300,
              child: TextField(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  labelText: "Repeat a Password",
                  prefixIcon: Icon(Icons.password_rounded),
                ),
              ),
            ),

            const SizedBox(height: 16),

            FilledButton(
              onPressed: () => print("Register attempt"),
              style: FilledButton.styleFrom(minimumSize: const Size(300, 50)),
              child: const Text('Create an Account'),
            ),
          ],
        ),
      ),
    );
  }
}
