import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isLogin = true;
  String? _errorMessage;
  String _infoMessage = '';

  Future<void> _signInOrRegister() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _infoMessage = '';
    });

    try {
      if (_isLogin) {
        // Přihlášení
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } else {
        // Registrace
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        _infoMessage = 'Registrace proběhla úspěšně!';
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      setState(() {
        _errorMessage = 'Přihlášení přes Google selhalo: $e';
      });
    }
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() {
        _errorMessage = 'Zadej svůj e-mail pro obnovení hesla.';
      });
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      setState(() {
        _infoMessage = 'E-mail pro obnovení hesla byl odeslán.';
        _errorMessage = null;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Chyba při odesílání e-mailu: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = _isLogin ? 'Přihlášení' : 'Registrace';
    final buttonLabel = _isLogin ? 'Přihlásit se' : 'Registrovat';

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SvgPicture.asset(
                  'assets/symbol.svg',
                  height: 120,
                ),
                const SizedBox(height: 32),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Heslo',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _isLogin ? _resetPassword : null,
                    child: const Text('Zapomenuté heslo?'),
                  ),
                ),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                if (_infoMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      _infoMessage,
                      style: const TextStyle(color: Colors.green),
                    ),
                  ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _signInOrRegister,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : Text(buttonLabel),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: _signInWithGoogle,
                  icon: const Icon(Icons.account_circle),
                  label: const Text('Přihlásit se přes Google'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                      _errorMessage = null;
                      _infoMessage = '';
                    });
                  },
                  child: Text(_isLogin
                      ? 'Nemáš účet? Zaregistruj se'
                      : 'Máš účet? Přihlas se'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
