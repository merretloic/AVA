import asyncio
import websockets

async def test_prolog_server():
    uri = "ws://localhost:8080/ws"
    async with websockets.connect(uri) as websocket:
        # Envoyer une requête
        message = "utilisateur_type(25, homme, 70, 8, moderee, 3, vrai, 2500, 2)."
        print(f"Envoi : {message}")
        await websocket.send(message)

        # Recevoir la réponse
        response = await websocket.recv()
        print(f"Réponse : {response}")

asyncio.run(test_prolog_server())