import 'package:flutter/material.dart';
import 'package:ava/common/constants.dart';
import 'package:ava/common/loading.dart';
import 'package:ava/services/authentication.dart';

// Importe la classe AboutScreen
import 'about_screen.dart';

class AuthenticateScreen extends StatefulWidget {
  const AuthenticateScreen({Key? key}) : super(key: key);

  @override
  _AuthenticateScreenState createState() => _AuthenticateScreenState();
}

class _AuthenticateScreenState extends State<AuthenticateScreen> {
  final AuthenticationService _auth = AuthenticationService();
  final _formKey = GlobalKey<FormState>();

  bool loading = false;
  bool showSignIn = true; // Gère l’état SignIn vs Register
  bool showAbout = false; // Gère l’affichage de l’écran À propos
  String error = '';

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Permet de basculer entre SignIn et Register
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
    // 1) Si on veut afficher l'écran "À propos", on le retourne directement
    if (showAbout) {
      return AboutScreen(
        // On choisit quel texte afficher sur le bouton en haut à droite
        buttonLabel: showSignIn ? 'Register' : 'Sign In',
        onReturn: () {
          // Au clic, on repasse showAbout à false pour revenir à la page Auth
          setState(() {
            showAbout = false;
          });
        },
      );
    }

    // 2) Sinon, on affiche l’écran d’authentification habituel
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
                    // AppBar
                    AppBar(
                      backgroundColor: Colors.black,
                      elevation: 0.0,
                      leading: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/logo.png', // Logo monochrome
                        ),
                      ),
                      title: Text(
                        showSignIn ? 'Sign in to AVA' : 'Register to AVA',
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      actions: [
                        // Bouton pour basculer entre Sign In et Register
                        TextButton.icon(
                          icon: const Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          label: Text(
                            showSignIn ? 'Register' : 'Sign In',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          onPressed: toggleView,
                        ),

                        // Bouton "À propos"
                        TextButton.icon(
                          icon: const Icon(
                            Icons.info,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'À propos',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          onPressed: () {
                            // On n’utilise pas de route, on met juste showAbout = true
                            setState(() {
                              showAbout = true;
                            });
                          },
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.grey[800],
                      thickness: 1.0,
                      height: 1.0,
                    ),

                    // Formulaire
                    Expanded(
                      child: Center(
                        child: SingleChildScrollView(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black, // Couleur noire opaque
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            padding: const EdgeInsets.all(20.0),
                            margin: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxWidth: 400.0,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          showSignIn
                                              ? 'Welcome Back!'
                                              : 'Create Your Account',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 28.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 10.0),
                                        Text(
                                          'Please enter your details below to continue.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                        const SizedBox(height: 30.0),

                                        // Champ email
                                        TextFormField(
                                          controller: emailController,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                          decoration: textInputDecoration
                                              .copyWith(
                                            hintText: 'Email',
                                            hintStyle: TextStyle(
                                              color: Colors.grey[500],
                                            ),
                                            prefixIcon: Icon(
                                              Icons.email,
                                              color: Colors.grey[500],
                                            ),
                                            filled: true,
                                            fillColor: Colors.grey[900],
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey[700]!),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
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
                                        const SizedBox(height: 20.0),

                                        // Champ password
                                        TextFormField(
                                          controller: passwordController,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                          decoration: textInputDecoration
                                              .copyWith(
                                            hintText: 'Password',
                                            hintStyle: TextStyle(
                                              color: Colors.grey[500],
                                            ),
                                            prefixIcon: Icon(
                                              Icons.lock,
                                              color: Colors.grey[500],
                                            ),
                                            filled: true,
                                            fillColor: Colors.grey[900],
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey[700]!),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
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
                                        const SizedBox(height: 30.0),

                                        // Bouton Sign In / Register
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 15.0,
                                            ),
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
                                            style: const TextStyle(
                                              fontSize: 16.0,
                                            ),
                                          ),
                                          onPressed: () async {
                                            if (_formKey.currentState
                                                    ?.validate() ??
                                                false) {
                                              var email =
                                                  emailController.text.trim();
                                              var password =
                                                  passwordController.text.trim();

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
                                        const SizedBox(height: 15.0),

                                        // Message d'erreur éventuel
                                        if (error.isNotEmpty)
                                          Text(
                                            error,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
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
