const WebSocket = require('ws');

const ws = new WebSocket('ws://localhost:8081/ws');

// Complete test data with all required fields
const message = {
    type: 'get_recommendations',
    data: {
        age: 25,
        sexe: 'homme',
        poids: 70,
        sommeil: 8,
        activite: 120,
        calories: 2000,
        eau: 3.0,
        frequence_cardiaque: 80,
        vitamine_d: 10,
        temps_exposition: 15,
        surface_exposee: 'grande'
    }
};

// Add error handler
ws.on('error', (error) => {
    console.error('WebSocket error:', error);
});

ws.on('open', () => {
    console.log('Connected to ws://localhost:8081/ws');
    ws.send(JSON.stringify(message));
    console.log('Sent:', JSON.stringify(message, null, 2));
});

ws.on('message', (data) => {
    console.log('Received:', data.toString());
    // Don't close connection immediately
    setTimeout(() => {
        ws.close();
    }, 1000);
});

ws.on('close', () => {
    console.log('Connection closed');
    process.exit(0);
});

// Cleanup on process termination
process.on('SIGINT', () => {
    ws.close();
    process.exit(0);
});