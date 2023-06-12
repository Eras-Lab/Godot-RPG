from flask import Flask, render_template
import json

app = Flask(__name__)

@app.route('/')
def home():
    color_map = {
        'pick_up_item': '#800000',  # Maroon
        'use_item': '#000080',      # Navy
        'trade': '#008000',         # Green
        'train': '#808000',         # Olive
        'battle': '#800080',        # Purple
        'talk_to': '#008080',       # Teal
        'default': '#000000'        # Black
    }
    characters = []
    for filename in ["last_actions_Hero.txt", "last_actions_Ally1.txt", "last_actions_Ally2.txt"]:
        with open(filename, 'r') as file:
            character = {'name': filename.split('_')[2].split('.')[0], 'actions': []}
            for line in file:
                # Parse the json for each line
                command_data = json.loads(json.loads(line.strip())['action'])
                action_data = command_data['command']
                thoughts_data = command_data['thoughts']  # Get the thoughts data here

                # Add formatted action data to character
                character['actions'].append({
                    'action_type': action_data['action_type'],
                    'character_id': action_data['character_id'],
                    'parameters': action_data['parameters'],
                    'thoughts': thoughts_data,  # Use the thoughts data here
                    'feeling': action_data.get('feeling')  # .get() is used to avoid KeyError if 'feeling' is not present
                })

            characters.append(character)
    return render_template('index.html', characters=characters, color_map=color_map)

if __name__ == "__main__":
    app.run(debug=True)
