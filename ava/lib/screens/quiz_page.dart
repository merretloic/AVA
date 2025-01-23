import 'package:flutter/material.dart';
import 'package:ava/services/configurationManager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuizPage extends StatefulWidget {
  final ConfigurationManager configManager;

  const QuizPage({super.key, required this.configManager});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _currentQuestionIndex = 0;
  String _selectedAnswer = '';
  List<String> multipleChoices = [];
  List<Map<String, dynamic>> userAnswers = [];
  List<Map<String, dynamic>> quizQuestions = [
    {
      "type": "single-choice",
      "question": "Quelle est votre couleur préférée ?",
      "options": ["Rouge", "Bleu", "Vert", "Jaune"]
    },
    {
      "type": "multiple-choice",
      "question": "Quels fruits aimez-vous ?",
      "options": ["Pomme", "Banane", "Orange", "Fraise"]
    },
    {
      "type": "timeline",
      "question":
          "Combien d'heures de sommeil avez-vous dormi hier soir (basé sur votre style de vie actuel) ?",
      "options": ["0", "14"]
    },
  ];

  Future<void> _sendAnswersToFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'quizAnswers': userAnswers,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      print("Réponses envoyées avec succès !");
    } else {
      print("Aucun utilisateur connecté.");
    }
  }

  Widget _printQuestionAnswers(
      Map<String, dynamic> currentQuestion, List<String> options) {
    switch (currentQuestion["type"]) {
      case "single-choice":
        return Column(
          children: options.map((option) {
            final isSelected = _selectedAnswer == option;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSelected ? Colors.green : Colors.blue,
                  minimumSize: const Size(500, 50),
                ),
                onPressed: () {
                  setState(() {
                    _selectedAnswer = option;
                  });
                },
                child: Text(option, style: const TextStyle(fontSize: 18)),
              ),
            );
          }).toList(),
        );

      case "multiple-choice":
        return Column(
          children: [
            ...options.map((option) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 500,
                    maxWidth: 700,
                  ),
                  child: CheckboxListTile(
                    value: multipleChoices.contains(option),
                    onChanged: (bool? value) {
                      setState(() {
                        value == true
                            ? multipleChoices.add(option)
                            : multipleChoices.remove(option);
                      });
                    },
                    title: Text(option, style: const TextStyle(fontSize: 18)),
                    controlAffinity: ListTileControlAffinity.trailing,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16.0),
                    dense: true,
                  ),
                ),
              );
            }),
          ],
        );

      case "timeline":
        double selectedYear = double.parse(currentQuestion['options'][0]);
        double minYear = double.parse(currentQuestion['options'][0]);
        double maxYear = double.parse(currentQuestion['options'][1]);

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              children: [
                Slider(
                  value: selectedYear,
                  min: minYear,
                  max: maxYear,
                  divisions: (maxYear - minYear).toInt(),
                  label: selectedYear.toInt().toString(),
                  onChanged: (value) {
                    setState(() {
                      selectedYear = value;
                      _selectedAnswer = selectedYear.toInt().toString();
                    });
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  'Temps dormi : ${selectedYear.toInt()}h',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            );
          },
        );

      default:
        return const Center(
          child: Text(
            'Type de question inconnu',
            style: TextStyle(fontSize: 18, color: Colors.red),
            textAlign: TextAlign.center,
          ),
        );
    }
  }

  void _nextQuestion() {
    final currentQuestion = quizQuestions[_currentQuestionIndex];

    setState(() {
      // Stocker la réponse actuelle
      if (currentQuestion["type"] == "single-choice") {
        userAnswers.add({
          "question": currentQuestion["question"],
          "type": currentQuestion["type"],
          "answer": _selectedAnswer,
        });
      } else if (currentQuestion["type"] == "multiple-choice") {
        userAnswers.add({
          "question": currentQuestion["question"],
          "type": currentQuestion["type"],
          "answer": multipleChoices,
        });
      } else if (currentQuestion["type"] == "timeline") {
        userAnswers.add({
          "question": currentQuestion["question"],
          "type": currentQuestion["type"],
          "answer": _selectedAnswer,
        });
      }

      if (_currentQuestionIndex < quizQuestions.length - 1) {
        _currentQuestionIndex++;
        _selectedAnswer = '';
        multipleChoices = [];
      } else {
        widget.configManager.updateIsFormFilled();
        _sendAnswersToFirestore();
        Navigator.pop(context); // Revenir au menu principal
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = quizQuestions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Formulaire"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                currentQuestion["question"],
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              _printQuestionAnswers(currentQuestion,
                  List<String>.from(currentQuestion["options"])),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _nextQuestion();
                },
                child: const Text("Suivant", style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}