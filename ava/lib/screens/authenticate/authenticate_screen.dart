import 'package:flutter/material.dart';
import 'package:ava/common/constants.dart';
import 'package:ava/common/loading.dart';
import 'package:ava/services/authentication.dart';

class AuthenticateScreen extends StatefulWidget {
  @override
  _AuthenticateScreenState createState() => _AuthenticateScreenState();
}

class _AuthenticateScreenState extends State<AuthenticateScreen> {
  final AuthenticationService _auth = AuthenticationService();
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

    dynamic result = await _auth.registerWithEmailAndPassword(email, password);

    if (!mounted) return;

    if (result == "Email verification sent") {
      setState(() => loading = false);
      Navigator.of(context).pushReplacementNamed('/verify');
    } else if (result == null) {
      setState(() {
        loading = false;
        error = 'Failed to register. Please try again.';
      });
    }
  }

  Future<void> _handleSignIn(String email, String password) async {
    setState(() => loading = true);

    var result = await _auth.signInWithEmailAndPassword(email, password);

    if (!mounted) return;

    if (result == null) {
      setState(() {
        loading = false;
        error = 'Invalid email or password.';
      });
    } else {
      bool isVerified = await _auth.isEmailVerified();

      if (!mounted) return;

      if (isVerified) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        setState(() => loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            body: Stack(
              children: [
                // Image de fond
                Positioned.fill(
                  child: Image.asset(
                    'assets/fond.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                // Overlay sombre
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
                // Contenu principal
                Column(
                  children: [
                    AppBar(
                      backgroundColor: Colors.black,
                      elevation: 0.0,
                      leading: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset('assets/logo.png'), // Logo monochrome
                      ),
                      title: Text(
                        showSignIn ? 'Sign in to AVA' : 'Register to AVA',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      actions: [
                        TextButton.icon(
                          icon: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          label: Text(
                            showSignIn ? 'Register' : 'Sign In',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          onPressed: toggleView,
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.grey[800],
                      thickness: 1.0,
                      height: 1.0,
                    ),
                    Expanded(
                      child: Center(
                        child: SingleChildScrollView(
                          child: Container(
                            // Rectangle pour le formulaire
                            decoration: BoxDecoration(
                              color: Colors.black, // Couleur noire opaque
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            padding: const EdgeInsets.all(20.0),
                            margin:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  ConstrainedBox(
                                    constraints: BoxConstraints(maxWidth: 400.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          showSignIn
                                              ? 'Welcome Back!'
                                              : 'Create Your Account',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 28.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 10.0),
                                        Text(
                                          'Please enter your details below to continue.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                        SizedBox(height: 30.0),
                                        TextFormField(
                                          controller: emailController,
                                          style:
                                              TextStyle(color: Colors.white),
                                          decoration:
                                              textInputDecoration.copyWith(
                                            hintText: 'Email',
                                            hintStyle: TextStyle(
                                                color: Colors.grey[500]),
                                            prefixIcon: Icon(Icons.email,
                                                color: Colors.grey[500]),
                                            filled: true,
                                            fillColor: Colors.grey[900],
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey[700]!),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Enter an email';
                                            }
                                            return null;
                                          },
                                        ),
                                        SizedBox(height: 20.0),
                                        TextFormField(
                                          controller: passwordController,
                                          style:
                                              TextStyle(color: Colors.white),
                                          decoration:
                                              textInputDecoration.copyWith(
                                            hintText: 'Password',
                                            hintStyle: TextStyle(
                                                color: Colors.grey[500]),
                                            prefixIcon: Icon(Icons.lock,
                                                color: Colors.grey[500]),
                                            filled: true,
                                            fillColor: Colors.grey[900],
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey[700]!),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                          ),
                                          obscureText: true,
                                          validator: (value) {
                                            if (value == null ||
                                                value.length < 4) {
                                              return 'Enter a password with at least 4 characters';
                                            }
                                            return null;
                                          },
                                        ),
                                        SizedBox(height: 30.0),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 15.0),
                                            backgroundColor: Colors.white,
                                            foregroundColor: Colors.black,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                          ),
                                          child: Text(
                                            showSignIn
                                                ? 'Sign In'
                                                : 'Register',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                            ),
                                          ),
                                          onPressed: () async {
                                            if (_formKey.currentState
                                                    ?.validate() ??
                                                false) {
                                              var email =
                                                  emailController.text.trim();
                                              var password = passwordController
                                                  .text
                                                  .trim();

                                              if (showSignIn) {
                                                await _handleSignIn(
                                                    email, password);
                                              } else {
                                                await _handleRegister(
                                                    email, password);
                                              }
                                            }
                                          },
                                        ),
                                        SizedBox(height: 15.0),
                                        if (error.isNotEmpty)
                                          Text(
                                            error,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}