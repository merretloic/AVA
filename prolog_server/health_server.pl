% filepath: /c:/Users/kilia/eva/health_server.pl
:- discontiguous recommandation_sommeil/3.
:- discontiguous recommandation_activite/2.
:- discontiguous calcul_imc/3.
:- discontiguous plage_imc/3.

:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/websocket)).
:- use_module(library(http/json)).

:- http_handler(root(ws), http_upgrade_to_websocket(handle_ws, []), [spawn([])]).
 
start_server(Port) :-
    http_server(http_dispatch, [port(Port)]).

:- initialization(start_server(8081)).

handle_ws(WebSocket) :-
    ws_receive(WebSocket, Message),
    (   Message.opcode = close
    ->  true
    ;   handle_message(WebSocket, Message.data),
        handle_ws(WebSocket)
    ).

recommendations(poor, [
    "Go to bed earlier",
    "Avoid screens before bedtime",
    "Create a relaxing bedtime routine"
]).
recommendations(normal, [
    "Maintain current sleep schedule",
    "Consider sleep quality improvements"
]).
recommendations(optimal, [
    "Your sleep routine is great!",
    "Keep up the good habits"
]).

handle_message(WebSocket, Raw) :-
    format("Got raw message: ~w~n", [Raw]),
    atom_string(Raw, String),
    atom_json_dict(String, Dict, []),
    format("Got dict: ~w~n", [Dict]),
    (   Dict.type = "get_recommendations"
    ->  
        format("Got recommendations request~n", []),
        Sommeil = Dict.data.sommeil,
        format("Sommeil: ~w~n", [Sommeil]),
        Age = Dict.data.age,
        format("Age: ~w~n", [Age]),
        Sexe = Dict.data.sexe,
        format("Sexe: ~w~n", [Sexe]),
        Poids = Dict.data.poids,
        format("Poids: ~w~n", [Poids]),
        Activite = Dict.data.activite,
        format("Activite: ~w~n", [Activite]),
        Kcal = Dict.data.calories,
        format("Kcal: ~w~n", [Kcal]),
        Eau = Dict.data.eau,
        format("Eau: ~w~n", [Eau]),
        Freq_cardiaque = Dict.data.frequence_cardiaque,
        format("Freq_cardiaque: ~w~n", [Freq_cardiaque]),
        VitamineD_consomme = Dict.data.vitamine_d,
        format("VitamineD_consomme: ~w~n", [VitamineD_consomme]),
        TempsExposition = Dict.data.temps_exposition,
        format("TempsExposition: ~w~n", [TempsExposition]),
        SurfaceExposee = Dict.data.surface_exposee,
        format("SurfaceExposee: ~w~n", [SurfaceExposee]),
        
        get_recommendations(Age, Sexe, Poids, Sommeil, Activite, Kcal, Eau, Freq_cardiaque, VitamineD_consomme, TempsExposition, SurfaceExposee, Recommendations),
        % Lookup recommendations
        %log recommendations
        format("Recommendations: ~w~n", [Recommendations]),
        Reply = _{
            sommeil: Recommendations.sommeil,
            activite: Recommendations.activite,
            kcal: Recommendations.kcal,
            eau: Recommendations.eau,
            stress: Recommendations.stress,
            vitamine_d: Recommendations.vitamine_d

        },
        format("Reply: ~w~n", [Reply]),
        atom_json_dict(ReplyAtom, Reply, []),
        ws_send(WebSocket, text(ReplyAtom))
    ;   ws_send(WebSocket, text("{\"error\":\"unknown request\"}"))
    ).

determine_sleep_state(Hours, State) :-
    (   Hours < 6
    ->  State = poor
    ;   Hours > 8
    ->  State = optimal
    ;   State = normal
    ).

recommandation_sommeil(Age, Sommeil_min, Sommeil_max) :-
    Age >= 18, Age =< 64,
    Sommeil_min = 7, Sommeil_max = 9.
% Seniors (65+): 7 à 8 heures
recommandation_sommeil(Age, Sommeil_min, Sommeil_max) :-
    Age >= 65,
    Sommeil_min = 7, Sommeil_max = 8.
% Adolescents (14 à 17): 8 à 10 heures
recommandation_sommeil(Age, Sommeil_min, Sommeil_max) :-
    Age >= 14, Age =< 17,
    Sommeil_min = 8, Sommeil_max = 10.
% Enfants (6 à 13): 9 à 11 heures
recommandation_sommeil(Age, Sommeil_min, Sommeil_max) :-
    Age >= 6, Age =< 13,
    Sommeil_min = 9, Sommeil_max = 11.

verifier_sommeil(Age, Sommeil, Message) :-
    recommandation_sommeil(Age, Sommeil_min, Sommeil_max),
    (   Sommeil < Sommeil_min
    ->  Message = 'Vous n\'avez pas assez dormi. Essayez d\'augmenter votre temps de sommeil...'
    ;   Sommeil > Sommeil_max
    ->  Message = 'Vous avez dormi plus que le temps recommandé. Essayez de viser...'
    ;   Message = 'Votre temps de sommeil respecte les recommandations. Continuez ainsi !'
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
    format("Debug verifier_kcal - Age: ~w, Sexe: ~w, Poids: ~w, Kcal: ~w~n", [Age, Sexe, Poids, Kcal]),
    (   Kcal_consomme < 2000
    ->  Message = 'Augmentez votre apport calorique.'
    ;   Kcal_consomme > 2500
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
% Add debug prints to verifier_eau
verifier_eau(Age, Eau, Message) :-
    format("Debug verifier_eau - Age: ~w, Eau: ~f", [Age, Eau]),
    (Age >= 18 ->
        % Adult recommendations
        format("Debug - Adult water check~n"),
        (Eau < 2 ->
            Message = 'Augmentez votre consommation d\'eau à au moins 2L par jour'
        ; Eau > 4 ->
            Message = 'Votre consommation d\'eau est peut-être excessive'
        ;
            Message = 'Votre consommation d\'eau est conforme aux recommandations'
        )
    ;
        % Child recommendations
        format("Debug - Child water check~n"),
        (Eau < 1.5 ->
            Message = 'Augmentez la consommation d\'eau à au moins 1.5L par jour'
        ; Eau > 3 ->
            Message = 'La consommation d\'eau est peut-être excessive'
        ;
            Message = 'La consommation d\'eau est conforme aux recommandations'
        )
    ).

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
    (   Age < 18
    ->  VitamineD_recommandee = 15    % Enfants et adolescents
    ;   Age >= 18, Age < 65
    ->  VitamineD_recommandee = 15    % Adultes
    ;   Age >= 65
    ->  VitamineD_recommandee = 20    % Seniors
    ).

% Vérification de l'apport en vitamine D sans prise en compte de l'exposition au soleil
verifier_vitamine_d(Age, VitamineD_consomme, Message) :-
    format("Debug verifier_vitamine_d - Age: ~w, VitamineD_consomme: ~w~n", [Age, VitamineD_consomme]),
    recommandation_vitamine_d(Age, VitamineD_recommandee),
    format("Debug recommandation_vitamine_d - VitamineD_recommandee: ~w~n", [VitamineD_recommandee]),
    (   VitamineD_consomme < VitamineD_recommandee
    ->  Manque is VitamineD_recommandee - VitamineD_consomme,
        format(string(Message), 'Vous manquez de ~2f µg de vitamine D. Augmentez votre consommation d\'aliments riches en vitamine D.', [Manque])
    ;   Message = 'Votre apport en vitamine D est suffisant. Continuez à maintenir cet équilibre nutritionnel.'
    ).


% % Calcul de l IMC

% calcul_imc(Poids, Taille, IMC) :-
%     Taille > 0,
%     Poids > 0,
%     IMC is  Poids / (Taille * Taille).

% % Définition des plages d IMC selon l âge
% plage_imc(Age, IMC_min, IMC_max) :-
%     (   Age >= 18, Age =< 64
%     ->  IMC_min = 18.5, IMC_max = 24.9
%     ;   Age >= 65
%     ->  IMC_min = 22, IMC_max = 27
%     ;   Age >= 2, Age =< 17
%     ->  IMC_min >= 18, IMC_max = 24
%     ).

get_recommendations(Age, Sexe, Poids, Sommeil, Activite, Kcal, Eau, Freq_cardiaque, VitamineD_consomme, TempsExposition, SurfaceExposee, Recommendations) :- 
    format("Calcul des recommandations pour l'âge ~w, le sexe ~w, le poids ~w, le sommeil ~w, l'activité ~w, les calories ~w, l'eau ~w, la fréquence cardiaque ~w, la vitamine D ~w, le temps d'exposition ~w et la surface exposée ~w~n", [Age, Sexe, Poids, Sommeil, Activite, Kcal, Eau, Freq_cardiaque, VitamineD_consomme, TempsExposition, SurfaceExposee]),
    % Vérification du sommeil
    verifier_sommeil(Age, Sommeil, MessageSommeil),
    format("Message sommeil: ~w~n", [MessageSommeil]),
    % Vérification de l activité physique
    verifier_activite(Age, Activite, MessageActivite),
    format("Message activité: ~w~n", [MessageActivite]),
    % Vérification des calories
    verifier_kcal(Age, Sexe, Poids, Kcal, MessageKcal),
    format("Message kcal: ~w~n", [MessageKcal]),
    % Vérification de l hydratation
    format("test verifier_eau~n"),
    format("Debug, Eau: ~w~n", [Eau]),
    verifier_eau(Age, Eau, MessageEau),
    format("Message eau: ~w~n", [MessageEau]),
    % Vérification du stress
    verifier_stress(Age, Freq_cardiaque, MessageStress),
    format("Message stress: ~w~n", [MessageStress]),
    % Vérification de la vitamine D
    verifier_vitamine_d(Age, VitamineD_consomme, MessageVitamineD),
    format("Message vitamine D: ~w~n", [MessageVitamineD]),
   
    % Vérification de la santé globale

    % Résultat global sous forme de liste
    Recommendations = [
        sommeil: MessageSommeil,
        activite: MessageActivite,
        kcal: MessageKcal,
        eau: MessageEau,
        stress: MessageStress,
        vitamine_d: MessageVitamineD
    ].





%TESTS 
% get_recommendations(25, homme, 70, 8, 120, 2000, 3, 80, 10, 15, 'grande', Recommendations).