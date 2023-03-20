import json
import subprocess
from http.server import HTTPServer, BaseHTTPRequestHandler


class RequestHandler(BaseHTTPRequestHandler):
    def do_POST(self):
        content_length = int(self.headers['Content-Length'])
        post_data = self.rfile.read(content_length)
        payload = json.loads(post_data.decode())

        command = payload.get('command')
        if not command:
            response_data = {'error': 'No command provided'}
        else:
            # Run the R script and get the result
            # result = subprocess.check_output(['Rscript', '-e', command])
            # response_data = {'result': result.decode()}
            # log in console
            response_data = {'result': "Nog niet geimplementeerd"}
            print(command)

        response = json.dumps(response_data).encode()
        self.send_response(200)
        self.send_header('Content-Type', 'application/json')
        self.send_header('Content-Length', len(response))
        self.end_headers()
        self.wfile.write(response)


if __name__ == '__main__':
    server_address = ('', 8000)
    httpd = HTTPServer(server_address, RequestHandler)
    httpd.serve_forever()