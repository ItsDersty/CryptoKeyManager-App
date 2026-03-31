import 'package:cryptkey_manager_app/screens/main/main_screen.dart';
import 'package:cryptkey_manager_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:cryptkey_manager_app/screens/auth/register_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  var _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final api = Provider.of<ApiService>(context, listen: false);

      setState(() {
        _isLoading = true;
      });

      try {
        final result = await api.login(
          _usernameController.text,
          _passwordController.text,
        );

        if (result != null && mounted) {
          // success
          print("Success! Token: ${result['access']}");
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const MainScreen()),
            (route) => false,
          );
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid email or password')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Log in",
                  style: Theme.of(context).textTheme.displayMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Email
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: _usernameController,
                    //keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      labelText: "Username",
                      prefixIcon: Icon(Icons.person),
                    ),

                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Please enter username';
                      //if (!value.contains('@')) return 'Enter a valid email';
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // pass
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      labelText: "Password",
                      prefixIcon: Icon(Icons.password_rounded),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Please enter password';
                      //if (value.length < 6) return 'Password too short';
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 24),

                FilledButton(
                  onPressed: _handleLogin,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(300, 56),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,

                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        )
                      : const Text('Log in'),
                ),

                const SizedBox(height: 12),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    );
                  },
                  child: const Text("Don't have an account? Sign up!"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
