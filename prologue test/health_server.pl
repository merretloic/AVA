% filepath: /c:/Users/kilia/eva/health_server.pl
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
    (   Dict.type = "get_sleep_state"
    ->  Hours = Dict.data,
        determine_sleep_state(Hours, State),
        % Lookup recommendations
        recommendations(State, Recs),
        Reply = _{
            state: State,
            recommendations: Recs
        },
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