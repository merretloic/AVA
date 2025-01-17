import 'package:flutter/material.dart';
import 'package:ava/configurationManager.dart';

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
      "question": "Sélectionnez une année",
      "options": ["2000", "2025"]
    },
  ];

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
                  'Année sélectionnée : ${selectedYear.toInt()}',
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
    setState(() {
      if (_currentQuestionIndex < quizQuestions.length - 1) {
        _currentQuestionIndex++;
        _selectedAnswer = '';
        multipleChoices = [];
      } else {
        setState(() {
          widget.configManager.updateIsFormFilled();
        });
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentQuestion["question"],
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _printQuestionAnswers(
                currentQuestion, List<String>.from(currentQuestion["options"])),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                _nextQuestion();
              },
              child: const Text("Suivant", style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}