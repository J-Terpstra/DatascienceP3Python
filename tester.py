import requests
import json

url = "http://localhost:8000"

# Define the command
command = "print('Hello, world!')"

# Create a JSON payload with the command
payload = {'command': command}

try:
    # Send a POST request to the server with the payload
    response = requests.post(url, json=payload)

    # Decode the response JSON data
    response_data = json.loads(response.text)

    # Print the response data
    print(response_data)

except requests.exceptions.ConnectionError as e:
    # Handle connection error gracefully
    print(f"Connection error: {e}")
