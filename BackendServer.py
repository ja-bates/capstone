from http.server import BaseHTTPRequestHandler, HTTPServer
import json

class SimpleHTTPRequestHandler(BaseHTTPRequestHandler):

    # Define what to do when a POST request is received
    def do_POST(self):
        # Get the length of the data and read it from the request
        content_length = int(self.headers['Content-Length'])
        body = self.rfile.read(content_length).decode('utf-8')

        # Convert the received data from JSON format to a Python dictionary
        #print(body)  #debug
        #data = json.loads(body.decode('utf-8'))
        print("Received:", body)
        
        #200 = standard response for successful HTTP
        self.send_response(200) 

        # End the HTTP headers section (headers are sent with send_response)
        self.end_headers()

        # Prepare a response to send back to the client
        response = bytes("Data received and sent to Arduino", "utf-8")
        
        # Write the response data to the output stream, sending it back to the client
        self.wfile.write(response)

# Set up and start an HTTP server, port 50000, '0.0.0.0' means all available interfaces
httpd = HTTPServer(('0.0.0.0', 50000), SimpleHTTPRequestHandler)
# Start the server, and keep it running indefinitely
httpd.serve_forever()
