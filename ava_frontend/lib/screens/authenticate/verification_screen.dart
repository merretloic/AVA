import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VerificationScreen extends StatefulWidget {
  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  Future<void> _checkEmailVerified() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:5000/check-verification'),
        headers: {'Content-Type': 'application/json'},
      );

      if (!mounted) return;

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200 && responseData['verified']) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _checkEmailVerified();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Verify your email")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "A verification email has been sent to your email address.",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text("Check Email Verification"),
              onPressed: () async {
                await _checkEmailVerified();
              },
            ),
          ],
        ),
      ),
    );
  }
}