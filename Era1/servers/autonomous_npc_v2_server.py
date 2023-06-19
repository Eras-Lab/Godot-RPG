from flask import Flask, request, jsonify
from chatgpt import ChatGPT

app = Flask(__name__)

chat_agents = {}

@app.route('/chat', methods=['POST'])
def chat():
    data = request.get_json()

    if 'message' not in data or 'player_id' not in data:
        return jsonify({'error': 'message and player_id are required fields'}), 400

    user_input = data['message']
    player_id = data['player_id']

    print("User input:", user_input)

    if player_id not in chat_agents:
        api_key = "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"
        filepath = '../prompts/chatbot10.txt'

        # Initialize new ChatGPT agent for the player
        chat_agents[player_id] = ChatGPT(api_key, filepath)
    
    # Get chatbot response
    response = chat_agents[player_id].chat(user_input)
    
    return jsonify(response)

if __name__ == '__main__':
    # Start the server
    app.run(port=5000, debug=True)
