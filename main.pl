:- use_module(library(socket)).
:- use_module(library(http/json)).


% --- Définition de l utilisateur type ---

% Utilisateur type
utilisateur_type(
    25,          % Age (adulte)
    homme,       % Sexe
    150,          % Poids (en kg)
    1.70,         % Taille (en M)
    8,           % Sommeil (en heures)
    120,         % Activité modérée (en minutes par semaine)
    50,          % Activité intense (en minutes par semaine)
    2,           % Jours de musculation
    2800,        % Calories consommées
    3,            % Eau consommée (en litres)
    non,          % Tabac
    non,          % Alcool
    equilibree,   % Alimentation
    80,           % Frequence cardiaque
    16,           % VitamineD consomme
    4,           % TempsExposition
    grande        % Surface exposée
).

% --- Recommandations de sommeil ---

% Adultes de 18 à 64 ans : 7 à 9 heures de sommeil par nuit
recommandation_sommeil(Age, Sommeil_min, Sommeil_max) :-
    Age >= 18, Age =< 64,
    Sommeil_min = 7, Sommeil_max = 9.

% Personnes âgées de 65 ans et plus : 7 à 8 heures de sommeil par nuit
recommandation_sommeil(Age, Sommeil_min, Sommeil_max) :-
    Age >= 65,
    Sommeil_min = 7, Sommeil_max = 8.

% Adolescents de 14 à 17 ans : 8 à 10 heures de sommeil par nuit
recommandation_sommeil(Age, Sommeil_min, Sommeil_max) :-
    Age >= 14, Age =< 17,
    Sommeil_min = 8, Sommeil_max = 10.

% Enfants de 6 à 13 ans : 9 à 11 heures de sommeil par nuit
recommandation_sommeil(Age, Sommeil_min, Sommeil_max) :-
    Age >= 6, Age =< 13,
    Sommeil_min = 9, Sommeil_max = 11.

% --- Vérification du sommeil ---

% Règle principale pour vérifier la conformité au temps de sommeil recommandé
verifier_sommeil(Age, Sommeil, Message) :-
    recommandation_sommeil(Age, Sommeil_min, Sommeil_max),
    (   Sommeil < Sommeil_min
    ->  Message = 'Vous n\'avez pas assez dormi. Essayez d\'augmenter votre temps de sommeil pour respecter les recommandations.'
    ;   Sommeil > Sommeil_max
    ->  Message = 'Vous avez dormi plus que le temps recommandé. Essayez de viser un sommeil de qualité entre les valeurs recommandées.'
    ;   Message = 'Votre temps de sommeil respecte les recommandations pour votre âge. Continuez ainsi pour une bonne santé !'
    ).

% --- Définition des recommandations d activité ---

recommandation_activite(Age, Activite_min) :-
    (   Age >= 18
    ->  Activite_min = 150  % Minutes par semaine pour les adultes
    ;   Age >= 6, Age =< 17
    ->  Activite_min = 60   % Minutes par jour pour les enfants et adolescents
    ;   throw(error(invalid_age(Age), 'Age must be 6 or above'))
    ).


% --- Vérification des activités physiques ---
verifier_activite(Age, Activite_effectuee, Message) :-
    recommandation_activite(Age, Activite_min),
    (   Activite_effectuee < Activite_min
    ->  Message = 'L activité physique est importante pour l équilibre physique et morale ! Encore un petit effort.'
    ;   Message = 'Bravo ! Vous respectez les recommandations d\'activité physique.'
    ).



% --- Recommandations caloriques ---

% Calcul des besoins caloriques en fonction du poids
calcule_besoins_caloriques(Poids, Kcal_min, Kcal_max) :-
    (   Poids < 50
    ->  Kcal_min = 1800, Kcal_max = 1900
    ;   Poids =< 75
    ->  Kcal_min = 2000, Kcal_max = 2200
    ;   Kcal_min = 2200, Kcal_max = 2500
    ).

% Recommandations caloriques selon âge et sexe
recommandation_kcal(Age, Sexe, Poids, Kcal_min, Kcal_max) :-
    calcule_besoins_caloriques(Poids, Kcal_min, Kcal_max),
    (   Sexe = homme, Age >= 18, Age =< 64
    ;   Sexe = femme, Age >= 18, Age =< 64
    ;   Age >= 65
    ;   Age >= 14, Age =< 17
    ;   Age >= 6, Age =< 13
    ).

% Vérification des calories consommées
verifier_kcal(Age, Sexe, Poids, Kcal_consomme, Message) :-
    recommandation_kcal(Age, Sexe, Poids, Kcal_min, Kcal_max),
    (   Kcal_consomme < Kcal_min
    ->  Message = 'Augmentez votre apport calorique.'
    ;   Kcal_consomme > Kcal_max
    ->  Message = 'Réduisez votre apport calorique.'
    ;   Message = 'Votre apport calorique est adapté. Continuez ainsi !'
    ).

% --- Recommandations d eau ---

% Recommandations générales pour adultes
recommandation_eau(Age, Eau_min, Eau_max) :-
    (   Age >= 18
    ->  Eau_min = 3, Eau_max = 5
    ;   Age < 18
    ->  Eau_min = 2, Eau_max = 3
    ).

% Règle principale pour vérifier la conformité à la quantité d eau recommandée
verifier_eau(Age, Eau, Message) :-
    recommandation_eau(Age, Eau_min, Eau_max),
    (   Eau < Eau_min
    ->  Message = 'Vous n\'avez pas consommé assez d\'eau. Essayez d\'augmenter votre consommation d\'eau pour atteindre la quantité recommandée.'
    ;   Eau > Eau_max
    ->  Message = 'Vous avez consommé plus d\'eau que la quantité recommandée. Essayez de vous limiter à la quantité suggérée.'
    ;   Message = 'Votre consommation d\'eau est conforme aux recommandations pour votre âge et votre sexe. Continuez ainsi pour rester hydraté !'
    ).

% Exemple de consultation :
% ?- verifier_eau(25, homme, 3, Message).
% Message = 'Votre consommation d\'eau est conforme aux recommandations pour votre âge et votre sexe. Continuez ainsi pour rester hydraté !'

% ?- verifier_eau(25, femme, 2, Message).
% Message = 'Vous n\'avez pas consommé assez d\'eau. Essayez d\'augmenter votre consommation d\'eau pour atteindre la quantité recommandée.'

% ?- verifier_eau(12, homme, 1.5, Message).
% Message = 'Vous avez consommé plus d\'eau que la quantité recommandée. Essayez de vous limiter à la quantité suggérée.'

% Recommandations de temps d écran en fonction de l âge
recommandation_temps_ecran(Age, Temps_max) :-
    Age < 18, Temps_max = 2 ;      % Enfants et adolescents : 2 heures maximum par jour
    Age >= 18, Temps_max = 4.      % Adultes : 4 heures maximum par jour

% Vérification du temps d écran
verifier_temps_ecran(Age, Temps_ecran, Message) :-
    recommandation_temps_ecran(Age, Temps_max),
    (   Temps_ecran > Temps_max
    ->  Excess is Temps_ecran - Temps_max,
        format(atom(Message), 'Vous avez dépassé le temps d\'écran recommandé de ~d heure(s). Essayez de réduire votre exposition aux écrans.', [Excess])
    ;   Message = 'Votre temps d\'écran respecte les recommandations. Continuez ainsi pour protéger votre santé visuelle et mentale.'
    ).

% Recommandations de fréquence cardiaque au repos (valeurs normales)
recommandation_frequence_cardiaque(Age, Freq_min, Freq_max) :-
    Age >= 18, Freq_min = 60, Freq_max = 100 ;    % Adultes
    Age >= 6, Age < 18, Freq_min = 70, Freq_max = 110.  % Enfants et adolescents

% Vérification du stress via la fréquence cardiaque
verifier_stress(Age, Freq_cardiaque, Message) :-
    recommandation_frequence_cardiaque(Age, Freq_min, Freq_max),
    (   Freq_cardiaque < Freq_min
    ->  Message = 'Votre fréquence cardiaque est anormalement basse. Consultez un professionnel de santé.'
    ;   Freq_cardiaque > Freq_max
    ->  Message = 'Votre fréquence cardiaque est élevée, ce qui peut indiquer un niveau de stress élevé. Essayez des techniques de relaxation.'
    ;   Message = 'Votre fréquence cardiaque est dans la plage normale. Continuez à gérer votre stress efficacement.'
    ).

% Recommandations de vitamine D en microgrammes (µg) par jour
recommandation_vitamine_d(Age, VitamineD_recommandee) :-
    Age < 18, VitamineD_recommandee = 15 ;    % Enfants et adolescents
    Age >= 18, Age < 65, VitamineD_recommandee = 15 ;  % Adultes
    Age >= 65, VitamineD_recommandee = 20.   % Seniors

% Synthèse de la vitamine D selon le temps d exposition au soleil
synthese_vitamine_d(TempsExposition, SurfaceExposee, VitamineD_synthetisee) :-
    % Facteur basé sur la surface exposée (1 = bras et jambes, 0.5 = visage et mains seulement)
    (SurfaceExposee = 'grande' -> FacteurSurface = 1 ;
     SurfaceExposee = 'moyenne' -> FacteurSurface = 0.5 ;
     SurfaceExposee = 'faible' -> FacteurSurface = 0.2),
    % Synthèse calculée pour une exposition de base de 15 minutes (10 µg synthétisés)
    VitamineD_synthetisee is 10 * (TempsExposition / 15) * FacteurSurface.

% Vérification de l apport en vitamine D avec prise en compte de l exposition au soleil
verifier_vitamine_d(Age, VitamineD_consomme, TempsExposition, SurfaceExposee, Message) :-
    recommandation_vitamine_d(Age, VitamineD_recommandee),
    synthese_vitamine_d(TempsExposition, SurfaceExposee, VitamineD_synthetisee),
    TotalVitamineD is VitamineD_consomme + VitamineD_synthetisee,
    (   TotalVitamineD < VitamineD_recommandee
    ->  Manque is VitamineD_recommandee - TotalVitamineD,
        Message = 'Vous manquez de vitamine D. Augmentez votre exposition au soleil ou consommez des aliments riches en vitamine D.'
    ;   Message = 'Votre apport en vitamine D est suffisant. Continuez à maintenir cet équilibre nutritionnel.'
    ).

% Calcul de l IMC

calcul_imc(Poids, Taille, IMC) :-
    Taille > 0,
    Poids > 0,
    IMC is  Poids / (Taille * Taille).

% Définition des plages d IMC selon l âge
plage_imc(Age, IMC_min, IMC_max) :-
    (   Age >= 18, Age =< 64
    ->  IMC_min = 18.5, IMC_max = 24.9
    ;   Age >= 65
    ->  IMC_min = 22, IMC_max = 27
    ;   Age >= 2, Age =< 17
    ->  IMC_min >= 18, IMC_max = 24
    ).

% Règles combinées pour évaluer la santé d une personne

% Base de connaissances pour des seuils recommandés
recommandation_sommeil(Age, Sommeil_min, Sommeil_max). % heures par nuit
recommandation_activite(Age, Activite_min). % minutes par semaine
calcul_imc(Poids,Taille,IMC).
plage_imc(Age, IMC_min, IMC_max).

% Facteurs de risque : tabac, alcool, alimentation déséquilibrée
facteur_risque(tabac).
facteur_risque(alcool).
facteur_risque(alimentation_desequilibree).

% Règles pour évaluer les risques de santé
risque_obesite(IMC) :-
    IMC > 30.
risque_infarctus(IMC, Activite, Tabac) :-
    (IMC > 30; Activite < 150; Tabac == oui).
risque_cancer(Tabac, Alcool, Alimentation) :-
    (Tabac == oui; Alcool == oui; Alimentation == desequilibree).

% Règle principale : bonne santé
recommandation_sante(Sommeil, Activite, IMC, Tabac, Alcool, Alimentation) :-
    utilisateur_type(Age, Sexe, Poids, Taille, Sommeil, Activite, Activite_intense, Musculation, Kcal, Eau, Tabac, Alcool, Alimentation, Freq_cardiaque, VitamineD_consomme, TempsExposition, SurfaceExposee),
    recommandation_sommeil(Age, Sommeil_min, Sommeil_max),
    Sommeil >= Sommeil_min, Sommeil =< Sommeil_max,
    recommandation_activite(Age, Activite_min),
    Activite >= Activite_min,
    calcul_imc(Poids,Taille,IMC),
    plage_imc(Age, IMC_min, IMC_max),
    IMC >= IMC_min, IMC =< IMC_max.

% Messages détaillés sur l état de santé
verifier_sante(Sommeil, Activite, IMC, Tabac, Alcool, Alimentation, Message) :-
    (   recommandation_sante(Sommeil, Activite, IMC, Tabac, Alcool, Alimentation)
    ->  Message = 'You are in good health! Keep maintaining a balanced lifestyle.'
    ;   (   risque_obesite(IMC)
        ->  Message = 'Risk of obesity detected. Consider adopting a healthier diet and increasing physical activity.'
        ;   (   risque_infarctus(IMC, Activite, Tabac)
            ->  Message = 'Risk of heart disease detected. Monitor your weight, increase physical activity, and avoid smoking.'
            ;   (   risque_cancer(Tabac, Alcool, Alimentation)
                ->  Message = 'Risk of cancer detected. Avoid tobacco and alcohol, and focus on a balanced diet.'
                ;   Message = 'No specific health risks detected, but some areas may need attention. Keep monitoring your health!'
                )
            )
        )
    ).




tester_regles :-
    utilisateur_type(Age, Sexe, Poids, Taille, Sommeil, Activite, Activite_intense, Musculation, Kcal, Eau, Tabac, Alcool, Alimentation, Freq_cardiaque, VitamineD_consomme, TempsExposition, SurfaceExposee),

    % Calcul de l IMC
    calcul_imc(Poids, Taille, IMC),
    format('IMC: ~w~n', [IMC]),

    % Vérification du sommeil
    verifier_sommeil(Age, Sommeil, MessageSommeil),
    format('Sommeil: ~w~n', [MessageSommeil]),

    % Vérification de l activité physique
    verifier_activite(Age, Activite, MessageActivite),
    format('Activités: ~w~n', [MessageActivite]),

    % Vérification des calories
    verifier_kcal(Age, Sexe, Poids, Kcal, MessageKcal),
    format('Calories: ~w~n', [MessageKcal]),

    % Vérification de l hydratation
    verifier_eau(Age, Eau, MessageEau),
    format('Eau: ~w~n', [MessageEau]),

    % Vérification du stress
    verifier_stress(Age, Freq_cardiaque, MessageStress),
    format('Stress: ~w~n', [MessageStress]),

    % Vérification de la vitamine D
    verifier_vitamine_d(Age, VitamineD_consomme, TempsExposition, SurfaceExposee, MessageVitamineD),
    format('Vitamine D: ~w~n', [MessageVitamineD]),

    % Vérification de la santé globale
    verifier_sante(Sommeil, Activite, IMC, Tabac, Alcool, Alimentation, MessageSante),
    format('Santé: ~w~n', [MessageSante]),

    % Résultat global sous forme de liste
    Result = [
        ['Sommeil', MessageSommeil],
        ['Activités', MessageActivite],
        ['Calories', MessageKcal],
        ['Eau', MessageEau],
        ['Stress', MessageStress],
        ['Vitamine D', MessageVitamineD],
        ['Bilan santé', MessageSante]
    ],
    format('Résultat global : ~w~n', [Result]).
