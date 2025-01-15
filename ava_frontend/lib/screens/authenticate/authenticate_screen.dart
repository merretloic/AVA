import 'package:flutter/material.dart';
import 'package:ava_frontend/common/constants.dart';
import 'package:ava_frontend/common/loading.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthenticateScreen extends StatefulWidget {
  @override
  _AuthenticateScreenState createState() => _AuthenticateScreenState();
}

class _AuthenticateScreenState extends State<AuthenticateScreen> {
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool showSignIn = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void toggleView() {
    setState(() {
      _formKey.currentState?.reset();
      error = '';
      emailController.text = '';
      passwordController.text = '';
      showSignIn = !showSignIn;
    });
  }

  Future<void> _handleRegister(String email, String password) async {
    setState(() => loading = true);
    try {
      final response = await http.post(
        Uri.parse('http://localhost:5000/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (!mounted) return;

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200 && responseData['status'] == 'success') {
        setState(() => loading = false);
        Navigator.of(context).pushReplacementNamed('/verify');
      } else {
        setState(() {
          loading = false;
          error = responseData['error'] ?? 'Failed to register.';
        });
      }
    } catch (e) {
      setState(() {
        loading = false;
        error = 'Error: $e';
      });
    }
  }

  Future<void> _handleSignIn(String email, String password) async {
    setState(() => loading = true);
    try {
      final response = await http.post(
        Uri.parse('http://localhost:5000/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (!mounted) return;

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200 && responseData['status'] == 'success') {
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        setState(() {
          loading = false;
          error = responseData['error'] ?? 'Invalid email or password.';
        });
      }
    } catch (e) {
      setState(() {
        loading = false;
        error = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.blueGrey,
              elevation: 0.0,
              title: Text(
                showSignIn ? 'Sign in to AVA' : 'Register to AVA',
              ),
              actions: <Widget>[
                TextButton.icon(
                  icon: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  label: Text(
                    showSignIn ? 'Sign In' : "Register",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 166, 228, 115),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () => toggleView(),
                ),
              ],
            ),
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      decoration: textInputDecoration.copyWith(hintText: 'email'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter an email";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: passwordController,
                      decoration:
                          textInputDecoration.copyWith(hintText: 'password'),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.length < 4) {
                          return "Enter a password with at least 4 characters";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10.0),
                    ElevatedButton(
                      child: Text(
                        showSignIn ? "Sign In" : "Register",
                        style: TextStyle(color: Colors.blue),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          var email = emailController.text.trim();
                          var password = passwordController.text.trim();

                          if (showSignIn) {
                            await _handleSignIn(email, password);
                          } else {
                            await _handleRegister(email, password);
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 15.0),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}