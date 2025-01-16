import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'firebase_options.dart';
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sleep Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AuthenticationWrapper(),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          return SleepScreen();
        }
        return SignInScreen();
      },
    );
  }
}

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign In')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _signIn,
              child: Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}

class SleepScreen extends StatefulWidget {
  @override
  _SleepScreenState createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {
  final _hoursController = TextEditingController();
  late WebSocketChannel _channel;
  String _response = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _connectWebSocket();
  }

  void _connectWebSocket() {
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://localhost:8081/ws'),
    );
    _channel.stream.listen(
      (data) {
        setState(() {
          _response = data.toString();
          _isLoading = false;
        });
        _saveToFirebase(data.toString());
      },
      onError: (error) {
        setState(() {
          _response = 'Error: $error';
          _isLoading = false;
        });
      },
    );
  }

  Future<void> _saveToFirebase(String response) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      await FirebaseFirestore.instance
          .collection('sleepData')
          .doc(userId)
          .collection('records')
          .add({
        'hours': double.tryParse(_hoursController.text) ?? 0,
        'response': response,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  void _sendSleepHours() {
    if (_hoursController.text.isEmpty) return;
    
    setState(() {
      _isLoading = true;
      _response = '';
    });

    final message = {
      "type": "get_sleep_state",
      "data": double.tryParse(_hoursController.text) ?? 0
    };
    
    // Convert to proper JSON string
    final jsonString = jsonEncode(message);
    print('Sending: $jsonString');
    _channel.sink.add(jsonString);
  }

  @override
  void dispose() {
    _channel.sink.close();
    _hoursController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sleep Tracker'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _hoursController,
              decoration: InputDecoration(
                labelText: 'Hours of Sleep',
                suffix: Text('hours'),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _sendSleepHours,
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text('Get Sleep State'),
            ),
            SizedBox(height: 24),
            if (_response.isNotEmpty)
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(_response),
                ),
              ),
          ],
        ),
      ),
    );
  }
}