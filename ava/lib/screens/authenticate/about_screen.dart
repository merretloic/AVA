import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  // Nom du bouton affiché dans la barre d’app (ex. 'Register' ou 'Sign In')
  final String buttonLabel;

  // Callback pour revenir à l’écran d’authentification
  final VoidCallback onReturn;

  const AboutScreen({
    Key? key,
    required this.buttonLabel,
    required this.onReturn,
  }) : super(key: key);

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
              // Barre d'app en haut
              AppBar(
                backgroundColor: Colors.black,
                elevation: 0.0,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/logo.png', // Logo monochrome
                  ),
                ),
                title: const Text(
                  'À propos d\'AVA',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                // On remplace l'icône "close" par un TextButton avec icône + label
                actions: [
                  TextButton.icon(
                    icon: const Icon(Icons.person, color: Colors.white),
                    label: Text(
                      buttonLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: onReturn,
                  ),
                ],
              ),

              Divider(
                color: Colors.grey[800],
                thickness: 1.0,
                height: 1.0,
              ),

              // Corps de la page
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Container(
                      // Rectangle noir
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: const EdgeInsets.all(20.0),
                      margin: const EdgeInsets.symmetric(horizontal: 20.0),
                      // Pour l'élargir, on peut soit augmenter le maxWidth, soit l'enlever.
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          // Si tu veux vraiment large, tu peux mettre 600, 800, etc.
                          maxWidth: 600.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Bienvenue dans l\'application AVA',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 30.0,  // plus grand
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 20.0),

                            // Premier paragraphe
                            Text(
                              'AVA est conçue pour accompagner et aider les utilisateurs '
                              'dans leurs tâches quotidiennes. Elle propose diverses '
                              'fonctionnalités afin de simplifier votre expérience, '
                              'améliorer votre productivité et vous offrir un espace '
                              'sûr et ergonomique. Nous espérons que vous apprécierez '
                              'l\'utiliser autant que nous avons aimé la développer.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18.0,  // plus grand
                                color: Colors.grey[300],
                              ),
                            ),
                            const SizedBox(height: 20.0),

                            // Deuxième paragraphe
                            Text(
                              'N\'hésitez pas à nous contacter pour toute question, '
                              'suggestion ou retour. Votre avis est essentiel pour '
                              'continuer à faire évoluer AVA selon vos besoins et vos '
                              'retours nous permettent de toujours vous offrir le meilleur '
                              'service possible.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.grey[300],
                              ),
                            ),
                            const SizedBox(height: 20.0),

                            // Troisième paragraphe (exemple de texte plus long)
                            Text(
                              'Notre équipe travaille continuellement à l\'amélioration de '
                              'l\'application. De nouvelles fonctionnalités sont prévues '
                              'prochainement : intégration de services tiers, gestion des '
                              'tâches avancée, rappels automatisés et bien plus. Restez '
                              'connectés pour découvrir ces évolutions.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.grey[300],
                              ),
                            ),
                            const SizedBox(height: 20.0),

                            // Quatrième paragraphe (optionnel)
                            Text(
                              'Merci de votre confiance et de faire partie de la communauté '
                              'AVA. Nous sommes ravis de vous compter parmi nous et '
                              'nous espérons que l\'application répondra à vos attentes '
                              'les plus exigeantes.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.grey[300],
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
