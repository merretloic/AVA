import 'package:flutter/material.dart';
import 'configurationManager.dart';

class Carousel extends StatelessWidget {
  final ConfigurationManager configManager;
  final int currentIndex;
  final Function onPrevious;
  final Function onNext;

  const Carousel({
    super.key,
    required this.configManager,
    required this.currentIndex,
    required this.onPrevious,
    required this.onNext,
  });

  String _getActivityTimeRange(int index) {
    final startHour = index;
    final endHour = (index + 1) % 24;
    return "${startHour.toString().padLeft(2, '0')}h-${endHour.toString().padLeft(2, '0')}h";
  }

  String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
        offset: const Offset(0, -50),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final height = constraints.maxHeight;
            return SizedBox(
              height: height,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // Activité précédente
                  Positioned(
                    left: -100,
                    child: SizedBox(
                      height: height * 0.27,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: configManager
                                    .currentLifeStyle
                                    .value[(currentIndex - 1 + 24) %
                                        configManager
                                            .currentLifeStyle.value.length]
                                    .color
                                    .withOpacity(0.5),
                              ),
                              padding: EdgeInsets.all(height * 0.16),
                              child: Icon(
                                configManager
                                    .currentLifeStyle
                                    .value[(currentIndex - 1 + 24) %
                                        configManager
                                            .currentLifeStyle.value.length]
                                    .icon
                                    .icon,
                                size: height * 0.14,
                                color: configManager
                                    .currentLifeStyle
                                    .value[(currentIndex - 1 + 24) %
                                        configManager
                                            .currentLifeStyle.value.length]
                                    .icon
                                    .color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Flèche précédente
                  Positioned(
                    left: 20,
                    top: height * 0.8,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back,
                          size: 48, color: Colors.black),
                      onPressed: () => onPrevious(),
                    ),
                  ),
                  // Activité principale
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Envelopper le Stack avec un widget SizedBox ou autre
                      SizedBox(
                        height: height * 0.6,
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: configManager
                                    .currentLifeStyle
                                    .value[currentIndex %
                                        configManager
                                            .currentLifeStyle.value.length]
                                    .color
                                    .withOpacity(0.8),
                                boxShadow: [
                                  BoxShadow(
                                    color: configManager
                                        .currentLifeStyle
                                        .value[currentIndex %
                                            configManager
                                                .currentLifeStyle.value.length]
                                        .color
                                        .withOpacity(0.6),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.all(height * 0.3),
                              child: Icon(
                                configManager
                                    .currentLifeStyle
                                    .value[currentIndex %
                                        configManager
                                            .currentLifeStyle.value.length]
                                    .icon
                                    .icon,
                                size: height * 0.18,
                                color: configManager
                                    .currentLifeStyle
                                    .value[currentIndex %
                                        configManager
                                            .currentLifeStyle.value.length]
                                    .icon
                                    .color,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _getActivityTimeRange(currentIndex),
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: configManager
                              .currentLifeStyle
                              .value[currentIndex %
                                  configManager.currentLifeStyle.value.length]
                              .color,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        capitalize(
                          configManager
                              .currentLifeStyle
                              .value[currentIndex %
                                  configManager.currentLifeStyle.value.length]
                              .name,
                        ),
                        style: const TextStyle(
                          fontSize: 25,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  // Activité suivante
                  Positioned(
                    right: -100,
                    child: SizedBox(
                      height: height * 0.27,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: configManager
                                    .currentLifeStyle
                                    .value[(currentIndex + 1) %
                                        configManager
                                            .currentLifeStyle.value.length]
                                    .color
                                    .withOpacity(0.5),
                              ),
                              padding: EdgeInsets.all(height * 0.16),
                              child: Icon(
                                configManager
                                    .currentLifeStyle
                                    .value[(currentIndex + 1) %
                                        configManager
                                            .currentLifeStyle.value.length]
                                    .icon
                                    .icon,
                                size: height * 0.14,
                                color: configManager
                                    .currentLifeStyle
                                    .value[(currentIndex + 1) %
                                        configManager
                                            .currentLifeStyle.value.length]
                                    .icon
                                    .color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Flèche suivante
                  Positioned(
                    right: 20,
                    top: height * 0.8,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward,
                          size: 48, color: Colors.black),
                      onPressed: () => onNext(),
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
}
