% Charger les bibliothèques nécessaires
:- use_module(library(http/websocket)).
:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).

% Charger les règles depuis main.pl
:- consult('main.pl').

% Lancer le serveur
start_server(Port) :-
    http_server(http_dispatch, [port(Port)]),
    writeln("Serveur lancé sur le port ":Port).

% Définir un endpoint WebSocket
:- http_handler(root(ws), http_upgrade_to_websocket(handle_websocket, []), [spawn([])]).

% Gestion des messages WebSocket
handle_websocket(WebSocket) :-
    ws_receive(WebSocket, Message),
    (   Message.opcode == text
    ->  process_message(Message.data, Response),
        ws_send(WebSocket, text(Response)),  % Envoyer la réponse au client Flutter
        handle_websocket(WebSocket)  % Continuer à écouter pour d autres messages
    ;   true).  % Arrêter si un message non textuel est reçu

% Traitement des messages WebSocket
process_message(ReceivedMessage, Response) :-
    % Convertir le message en terme Prolog
    (   atom_to_term(ReceivedMessage, Term, _)
    ->  (   Term = tester_regles  % Si la requête correspond à tester_regles
        ->  tester_regles(Result),
            format(atom(Response), '~w', [Result])  % Renvoyer les résultats au client
        ;   Response = 'Erreur : Règle non trouvée ou invalide')
    ;   Response = 'Erreur : Message invalide').  % Retourner une erreur si le message est invalide