import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ava/services/authentication.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  final AuthenticationService _auth = AuthenticationService();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Méthode pour envoyer des données à la base de données
  Future<void> _sendData() async {
    try {
      final data = {
        "categorie": "Exemple",
        "question": "Voici une super question, pas vrai ?",
        "reponse": "Bof Bof",
      };

      await _firestore.collection('Questions').add(data);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Données envoyées avec succès !')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'envoi des données : $e')),
      );
    }
  }

  /// Méthode pour afficher et retirer toutes les données
  Future<void> _retrieveAndDeleteData() async {
    try {
      final querySnapshot = await _firestore.collection('Questions').get();

      if (querySnapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Aucune donnée à afficher.')),
        );
        return;
      }

      // Afficher les données
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Données récupérées'),
            content: SingleChildScrollView(
              child: ListBody(
                children: querySnapshot.docs.map((doc) {
                  final data = doc.data();
                  return Text(data.toString());
                }).toList(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );

      // Supprimer les données après les avoir affichées
      for (var doc in querySnapshot.docs) {
        await _firestore.collection('Questions').doc(doc.id).delete();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Toutes les données ont été retirées.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du retrait des données : $e')),
      );
    }
  }

  /// Méthode pour déconnexion
  Future<void> _logout() async {
    try {
      await widget._auth.signOut();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Déconnexion réussie')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de la déconnexion')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AVA'),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Déconnexion',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _sendData,
              child: const Text('Envoyer les données'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _retrieveAndDeleteData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Retirer et afficher les données'),
            ),
          ],
        ),
      ),
    );
  }
}