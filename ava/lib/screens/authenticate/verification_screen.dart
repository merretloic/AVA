import 'package:flutter/material.dart';
import 'package:ava/services/authentication.dart';

class VerificationScreen extends StatefulWidget {
  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final AuthenticationService _auth = AuthenticationService();
  bool _isHovering = false; // Pour gérer l'état de survol de la flèche

  @override
  void initState() {
    super.initState();
    _checkEmailVerified();
  }

  Future<void> _checkEmailVerified() async {
    bool verified = await _auth.isEmailVerified();
    if (verified) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                // Flèche de retour : on survole -> couleur blanche un peu plus claire.
                leading: MouseRegion(
                  onEnter: (_) => setState(() => _isHovering = true),
                  onExit: (_) => setState(() => _isHovering = false),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: _isHovering ? Colors.white70 : Colors.white,
                    ),
                    // <-- On navigue vers '/', qui correspond à la page login/register
                    onPressed: () => Navigator.of(context).pushNamed('/'),
                  ),
                ),
                title: Text(
                  "Verify your email",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
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
                      decoration: BoxDecoration(
                        color: Colors.black, // Fond noir
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: const EdgeInsets.all(20.0),
                      margin: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Email Verification",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            "A verification email has been sent to your email address.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey[500],
                            ),
                          ),
                          SizedBox(height: 30.0),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 15.0),
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: Text("Check Email Verification"),
                            onPressed: () async {
                              await _checkEmailVerified();
                            },
                          ),
                        ],
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
