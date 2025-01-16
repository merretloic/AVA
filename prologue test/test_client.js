const WebSocket = require('ws');

const ws = new WebSocket('ws://localhost:8081/ws');

ws.on('open', () => {
  console.log('Connected to server');
  const message = {
    type: 'get_sleep_state',
    data: 7
  };
  console.log('Sending:', message);
  ws.send(JSON.stringify(message));
});

ws.on('message', (data) => {
  console.log('Raw received:', data.toString());
  try {
    const parsed = JSON.parse(data.toString());
    console.log('Parsed:', parsed);
  } catch (e) {
    console.error('Parse error:', e);
  }
});

ws.on('error', (error) => {
  console.error('WebSocket error:', error);
});

ws.on('close', (code, reason) => {
  console.log('Closed:', code, reason.toString());
});