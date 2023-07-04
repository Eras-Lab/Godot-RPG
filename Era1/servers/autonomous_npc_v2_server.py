from flask import Flask, request, jsonify
from chatgpt import ChatGPT

app = Flask(__name__)

chat_agents = {}

@app.route('/chat', methods=['POST'])
def chat():
    
    # Alter this value to change which system prompt to use
    # chatbot10: early version with assistant as researcher
    # chatbot11: more extensive system prompt with assistant as game strategist
    # chatbot12: very minimal system prompt - currently often returns response in wrong format
    # chatbot13: simplified version of chatbot11 - seems to not produce results as good as chatbot11
    ACTIVE_CHATBOT = "chatbot11"
    
    data = request.get_json()

    if 'message' not in data or 'player_id' not in data:
        return jsonify({'error': 'message and player_ids are required fields'}), 400

    # Construct the context data
    player_id = data['player_id'] 
    message = data['message']
    location = data['location'] if 'location' in data else "unknown"
    inventory = str(data['inventory']) if 'inventory' in data and data['inventory'] is not None and len(data['inventory']) > 0 else "none or unknown items" # ",".join(str(x) for x in inventory) is another option for constructing string
    funds = str(data['funds']) if 'funds' in data else "unknown amount" 
    monsters_nearby = str(data['monsters_nearby']) if 'monsters_nearby' in data and data['monsters_nearby'] is not None and len(data['monsters_nearby']) > 0 else "none or unknown monsters"
    players_nearby = str(data['players_nearby']) if 'players_nearby' in data and data['players_nearby'] is not None and len(data['players_nearby']) > 0 else "none or unknown players"
    buildings_nearby = str(data['buildings_nearby']) if 'buildings_nearby' in data and data['buildings_nearby'] is not None and len(data['buildings_nearby']) > 0 else "none or unknown buildings"
    items_nearby = str(data['items_nearby']) if 'items_nearby' in data and data['items_nearby'] is not None and len(data['items_nearby']) > 0 else "none or unknown items"
    
    # Put it all into one string for the user input
    user_input = f"CONTEXT: Here are the most recent actions completed by {player_id} (listed by most recent first):\n{message} \
    Here is additional context: {player_id} is currently located at {location}. He/she has an inventory \
    of {inventory}. He/she has funds equaling {funds}. Nearby monsters are {monsters_nearby}. Nearby players are {players_nearby}. \
    Nearby buildings are {buildings_nearby}. Nearby items are {items_nearby}."

    if ACTIVE_CHATBOT not in chat_agents:
        api_key = "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"
        filepath = f"../prompts/{ACTIVE_CHATBOT}.txt"

        # Initialize new ChatGPT agent for conversations
        chat_agents[ACTIVE_CHATBOT] = ChatGPT(api_key, filepath)
    
    # Get chatbot response
    response = chat_agents[ACTIVE_CHATBOT].chat(user_input)
    
    return jsonify(response)

# Version of chat() used for experimenting with generating a conversation between two players by providing full data for both of them
# @app.route('/converse', methods=['POST'])
# def converse():
#     data = request.get_json()

#     if 'message' not in data or 'player1_id' not in data or 'player2_id' not in data:
#         return jsonify({'error': 'message and player_ids are required fields'}), 400

#     message = data['message']
#     location = data['location'] if 'location' in data else "unknown"
#     player1_id = data['player1_id'] 
#     player2_id = data['player2_id'] 
#     player1_inventory = data['player1_inventory'] if 'player1_inventory' in data and len(data['player1_inventory']) > 0 else ["none or unknown items"]
#     player2_inventory = data['player2_inventory'] if 'player2_inventory' in data and len(data['player2_inventory']) > 0 else ["none or unknown items"]
#     player1_funds = data['player1_funds'] if 'player1_funds' in data else "unknown amount"
#     player2_funds = data['player2_funds'] if 'player2_funds' in data else "unknown amount"

#     user_input = "GOALS: " + message + "\n" + "CONTEXT: " + player1_id + " has encountered " + player2_id + " and started a conversation. Their location is " + location + ". " + player1_id + " has an inventory of " + ",".join(str(x) for x in player1_inventory) + ". " + player2_id + " has inventory of " + ",".join(str(x) for x in player2_inventory) + ". " + player1_id + " has funds equaling " + str(player1_funds) + " and " + player2_id + " has funds equaling " + str(player2_funds) + "."

#     if "conversations" not in chat_agents:
#         api_key = "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"
#         filepath = '../prompts/chatbot-converse-2.txt' 

#         # Initialize new ChatGPT agent for conversations
#         chat_agents["conversations"] = ChatGPT(api_key, filepath)
    
#     # Get chatbot response
#     response = chat_agents["conversations"].chat(user_input)
    
#     return jsonify(response)

if __name__ == '__main__':
    # Start the server
    app.run(port=5000, debug=True)
