% Utilisateur type
utilisateur_type(
    25,          % Age (adulte)
    homme,       % Sexe
    70,          % Poids (en kg)
    8,           % Sommeil (en heures)
    120,         % Activité modérée (en minutes par semaine)
    50,          % Activité intense (en minutes par semaine)
    2,           % Jours de musculation
    2800,        % Calories consommées
    3            % Eau consommée (en litres)
).


% Définition des recommandations de sommeil en fonction des groupes d âge

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

% Règle principale pour vérifier la conformité au temps de sommeil recommandé
verifier_sommeil(Age, Sommeil, Message) :-
    recommandation_sommeil(Age, Sommeil_min, Sommeil_max),
    (   Sommeil < Sommeil_min
    ->  Message = 'Vous n\'avez pas assez dormi. Essayez d\'augmenter votre temps de sommeil pour respecter les recommandations.'
    ;   Sommeil > Sommeil_max
    ->  Message = 'Vous avez dormi plus que le temps recommandé. Essayez de viser un sommeil de qualité entre les valeurs recommandées.'
    ;   Message = 'Votre temps de sommeil respecte les recommandations pour votre âge. Continuez ainsi pour une bonne santé !'
    ).

% Exemple de consultation sommeil:
% ?- verifier_sommeil(25, 6, Message).
% Message = 'Vous n\'avez pas assez dormi. Essayez d\'augmenter votre temps de sommeil pour atteindre au moins 7 heures.'

% ?- verifier_sommeil(25, 8, Message).
% Message = 'Votre temps de sommeil respecte les recommandations pour votre âge. Continuez ainsi pour une bonne santé !'

% ?- verifier_sommeil(25, 10, Message).
% Message = 'Vous avez dormi plus que le temps recommandé. Essayez de limiter votre sommeil à un maximum de 9 heures.'



% Recommandations d activité physique

% Recommandations pour les adultes (18 ans et plus)
recommandation_activite(Age, Activite_min, Activite_intense_min, Musculation_jours) :-
    Age >= 18,
    Activite_min = 150,            % 150 minutes d activité modérée par semaine
    Activite_intense_min = 75,     % ou 75 minutes d activité intense par semaine
    Musculation_jours = 2.         % 2 jours de musculation par semaine

% Recommandations pour les enfants et adolescents (6 à 17 ans)
recommandation_activite(Age, Activite_min, Activite_intense_jours, Musculation_jours) :-
    Age >= 6, Age =< 17,
    Activite_min = 60,             % 60 minutes d activité physique par jour
    Activite_intense_jours = 3,    % avec des activités intenses 3 jours par semaine
    Musculation_jours = 0.         % pas de recommandations spécifiques pour la musculation

% Vérification des activités physiques avec des recommandations personnalisées
verifier_activite(Age, Activite_effectuee, Activite_intense, Musculation) :-
    recommandation_activite(Age, Activite_min, Activite_intense_min, Musculation_jours),
    (   % Vérifier l activité modérée ou intense
        Activite_effectuee < Activite_min,
        Manque_activite is Activite_min - Activite_effectuee,
        format('Vous avez besoin d\'au moins ~d minutes supplémentaires d\'activité modérée pour atteindre les ~d minutes hebdomadaires recommandées.~n', [Manque_activite, Activite_min]),
        fail
    ;   Activite_intense < Activite_intense_min,
        Manque_intense is Activite_intense_min - Activite_intense,
        format('Vous avez besoin d\'au moins ~d minutes supplémentaires d\'activité intense pour atteindre les ~d minutes hebdomadaires recommandées.~n', [Manque_intense, Activite_intense_min]),
        fail
    ;   Musculation < Musculation_jours,
        Manque_musculation is Musculation_jours - Musculation,
        format('Il est recommandé de faire de la musculation au moins ~d jours par semaine. Essayez d\'ajouter ~d jour(s) supplémentaire(s) de musculation.~n', [Musculation_jours, Manque_musculation]),
        fail
    ).

verifier_activite(Age, Activite_effectuee, Activite_intense, Musculation) :-
    recommandation_activite(Age, Activite_min, Activite_intense_min, Musculation_jours),
    % Si aucune condition d échec n est remplie, on affiche le message de réussite
    Activite_effectuee >= Activite_min,
    Activite_intense >= Activite_intense_min,
    Musculation >= Musculation_jours,
    format('Bravo ! Vous respectez les recommandations d\'activité physique pour votre âge. Continuez ainsi !~n', []).

% Vérification pour les enfants et adolescents (sans musculation)
verifier_activite(Age, Activite_effectuee, Activite_intense_jours, _) :-
    Age >= 6, Age =< 17,
    recommandation_activite(Age, Activite_min, Activite_intense_jours_rec, _),
    (   Activite_effectuee < Activite_min,
        Manque_activite is Activite_min - Activite_effectuee,
        format('Vous avez besoin d\'au moins ~d minutes supplémentaires d\'activité physique quotidienne pour atteindre les ~d minutes recommandées.~n', [Manque_activite, Activite_min]),
        fail
    ;   Activite_intense_jours < Activite_intense_jours_rec,
        Manque_intense_jours is Activite_intense_jours_rec - Activite_intense_jours,
        format('Vous avez besoin d\'au moins ~d jour(s) supplémentaire(s) d\'activité intense par semaine pour atteindre les ~d jours recommandés.~n', [Manque_intense_jours, Activite_intense_jours_rec]),
        fail
    ).
verifier_activite(Age, Activite_effectuee, Activite_intense_jours, _) :-
    Age >= 6, Age =< 17,
    recommandation_activite(Age, Activite_min, Activite_intense_jours_rec, _),
    % Si aucune condition d échec n est remplie, on affiche le message de réussite
    Activite_effectuee >= Activite_min,
    Activite_intense_jours >= Activite_intense_jours_rec,
    format('Bravo ! Vous respectez les recommandations d\'activité physique pour votre âge. Continuez ainsi !~n', []).

% Exemples de consultations :
% ?- verifier_activite(25, 100, 60, 1).
% Vous avez besoin d au moins 50 minutes supplémentaires d activité modérée pour atteindre les 150 minutes hebdomadaires recommandées.

% ?- verifier_activite(25, 160, 80, 2).
% Bravo ! Vous respectez les recommandations d activité physique pour votre âge. Continuez ainsi !

% ?- verifier_activite(12, 50, 2, 0).
% Vous avez besoin d au moins 10 minutes supplémentaires d activité physique quotidienne pour atteindre les 60 minutes recommandées.

% Recommandations caloriques quotidiennes (en tenant compte du poids)

% Calcul des besoins caloriques en fonction du poids (avec un facteur d ajustement simplifié)
calcule_besoins_caloriques(Poids, Kcal_min, Kcal_max) :-
    (   Poids < 50
    ->  Kcal_min is 1800, Kcal_max is 1900 ;   % Moins de calories pour un poids faible
        Poids >= 50, Poids =< 75
    ->  Kcal_min is 2000, Kcal_max is 2200 ;   % Plage standard pour poids moyen
        Poids > 75
    ->  Kcal_min is 2200, Kcal_max is 2500   % Plus de calories pour un poids élevé
    ).

% Adultes hommes de 18 à 64 ans : ajustement en fonction du poids
recommandation_kcal(Age, Sexe, Poids, Kcal_min, Kcal_max) :-
    Sexe = homme,
    Age >= 18, Age =< 64,
    calcule_besoins_caloriques(Poids, Kcal_min, Kcal_max).

% Adultes femmes de 18 à 64 ans : ajustement en fonction du poids
recommandation_kcal(Age, Sexe, Poids, Kcal_min, Kcal_max) :-
    Sexe = femme,
    Age >= 18, Age =< 64,
    calcule_besoins_caloriques(Poids, Kcal_min, Kcal_max).

% Personnes âgées de 65 ans et plus
% Hommes : ajustement en fonction du poids
% Femmes : ajustement en fonction du poids
recommandation_kcal(Age, Sexe, Poids, Kcal_min, Kcal_max) :-
    Sexe = homme,
    Age >= 65,
    calcule_besoins_caloriques(Poids, Kcal_min, Kcal_max).

recommandation_kcal(Age, Sexe, Poids, Kcal_min, Kcal_max) :-
    Sexe = femme,
    Age >= 65,
    calcule_besoins_caloriques(Poids, Kcal_min, Kcal_max).

% Adolescents de 14 à 17 ans
% Hommes : ajustement en fonction du poids
% Femmes : ajustement en fonction du poids
recommandation_kcal(Age, Sexe, Poids, Kcal_min, Kcal_max) :-
    Sexe = homme,
    Age >= 14, Age =< 17,
    calcule_besoins_caloriques(Poids, Kcal_min, Kcal_max).

recommandation_kcal(Age, Sexe, Poids, Kcal_min, Kcal_max) :-
    Sexe = femme,
    Age >= 14, Age =< 17,
    calcule_besoins_caloriques(Poids, Kcal_min, Kcal_max).

% Enfants de 6 à 13 ans
% Ajustement en fonction du poids pour garçons et filles
recommandation_kcal(Age, Sexe, Poids, Kcal_min, Kcal_max) :-
    Sexe = homme,
    Age >= 6, Age =< 13,
    calcule_besoins_caloriques(Poids, Kcal_min, Kcal_max).

recommandation_kcal(Age, Sexe, Poids, Kcal_min, Kcal_max) :-
    Sexe = femme,
    Age >= 6, Age =< 13,
    calcule_besoins_caloriques(Poids, Kcal_min, Kcal_max).

% Vérification des calories consommées en fonction des recommandations
verifier_kcal(Age, Sexe, Poids, Kcal_consomme, Message) :-
    recommandation_kcal(Age, Sexe, Poids, Kcal_min, Kcal_max),
    (   Kcal_consomme < Kcal_min
    ->  Message = 'Vous n avez pas consommé assez de calories. Essayez d augmenter votre apport calorique.'
    ;   Kcal_consomme > Kcal_max
    ->  Message = 'Vous avez consommé trop de calories. Essayez de réduire votre apport calorique.'
    ;   Message = 'Votre apport calorique est adapté à votre âge, sexe et poids. Continuez ainsi pour une bonne santé !'
    ).

% Exemple de consultation :
% ?- verifier_kcal(25, homme, 70, 2500, Message).
% Message = 'Vous avez consommé trop de calories. Essayez de réduire votre apport calorique.'

% ?- verifier_kcal(70, femme, 80, 2300, Message).
% Message = 'Votre apport calorique est adapté à votre âge, sexe et poids. Continuez ainsi pour une bonne santé !'

% ?- verifier_kcal(17, homme, 60, 1900, Message).
% Message = 'Vous n avez pas consommé assez de calories. Essayez d augmenter votre apport calorique.'

% Définition des recommandations en therme de besoin d eau en fonction de l âge et du sexe

% Adultes : hommes (18 ans et plus) ont besoin de 3,5 litres d eau par jour
recommandation_eau(Age, Eau_min, Eau_max) :-
    Age >= 18,
    Eau_min = 3.5, Eau_max = 3.5.

% Adultes : femmes (18 ans et plus) ont besoin de 2,5 litres d eau par jour
recommandation_eau(Age, Eau_min, Eau_max) :-
    Age >= 18,
    Eau_min = 2.5, Eau_max = 2.5.

% Adolescents (14-17 ans) : 2 litres d eau par jour
recommandation_eau(Age, Eau_min, Eau_max) :-
    Age >= 14, Age =< 17,
    Eau_min = 2, Eau_max = 2.

% Enfants (6-13 ans) : 1,5 à 2 litres d eau par jour
recommandation_eau(Age, Eau_min, Eau_max) :-
    Age >= 6, Age =< 13,
    Eau_min = 1.5, Eau_max = 2.

% Personnes âgées de 65 ans et plus : 2 à 2,5 litres d eau par jour
recommandation_eau(Age, Eau_min, Eau_max) :-
    Age >= 65,
    Eau_min = 2, Eau_max = 2.5.

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
verifier_vitamine_d(Age, VitamineD_consomme, TempsExposition, SurfaceExposee) :-
    recommandation_vitamine_d(Age, VitamineD_recommandee),
    synthese_vitamine_d(TempsExposition, SurfaceExposee, VitamineD_synthetisee),
    TotalVitamineD is VitamineD_consomme + VitamineD_synthetisee,
    (   TotalVitamineD < VitamineD_recommandee
    ->  Manque is VitamineD_recommandee - TotalVitamineD,
        format('Vous manquez de ~f µg de vitamine D. Augmentez votre exposition au soleil ou consommez des aliments riches en vitamine D.', [Manque]),
        fail
    ;   format('Votre apport en vitamine D est suffisant. Continuez à maintenir cet équilibre nutritionnel.', [])
    ).




% Fonction qui teste toutes les règles pour l utilisateur type
tester_regles :-
    utilisateur_type(Age, Sexe, Poids, Sommeil, Activite, Activite_intense, Musculation, Kcal, Eau),
    
    % Vérification du sommeil
    verifier_sommeil(Age, Sommeil, MessageSommeil),
    format('Sommeil: ~w~n', [MessageSommeil]),
    
    % Vérification de l activité physique
    verifier_activite(Age, Activite, Activite_intense, Musculation),
    format('Activités: ~w~n', [MessageActivite]),
    
    % Vérification des calories
    verifier_kcal(Age, Sexe, Poids, Kcal, MessageKcal),
    format('Calories: ~w~n', [MessageKcal]),
    
    % Vérification de l hydratation
    verifier_eau(Age, Eau, MessageEau),
    format('Eau: ~w~n', [MessageEau]),


    Result = [
        ['Sommeil', MessageSommeil],
        ['Activités', MessageActivite],
        ['Calories', MessageKcal],
        ['Eau', MessageEau]
    ].



