// Load the http module to create an HTTP server.
const http = require('http');

// Configure the HTTP server to respond with "Hello World" to all requests.
const server = http.createServer((req, res) => {
  res.writeHead(200, {'Content-Type': 'text/plain'});
  res.end('Hello World\n');
});

// Listen on port 8080, IP defaults to 0.0.0.0
const PORT = 8080;
server.listen(PORT, () => {
  console.log(`Server is listening on port ${PORT}`);
});
