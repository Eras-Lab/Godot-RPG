import openai

class ChatGPT:
    def __init__(self, api_key, filepath):
        self.api_key = api_key
        self.short_term_memory = []
        self.system_prompt = self.open_file(filepath)
        openai.api_key = self.api_key

    def open_file(self, filepath):
        with open(filepath, 'r', encoding='utf-8') as infile:
            return infile.read()

    def save_file(self, filepath, content):
        with open(filepath, 'a', encoding='utf-8') as outfile:
            outfile.write(content)

    def chat(self, user_input, temperature=0, frequency_penalty=0.2, presence_penalty=0, max_turns=10):
        
        #  Code below for using short-term memory (commented out temporarily due to need for more testing)
        # self.short_term_memory.append({"role": "user","content": user_input})
        # # Only use the last max_turns turns of the short_term_memory
        # if len(self.short_term_memory) > max_turns * 2:
        #     self.short_term_memory = self.short_term_memory[-max_turns * 2:]
        # # Building the input prompt
        # messages_input = self.short_term_memory.copy()
        # prompt = [{"role": "system", "content": self.system_prompt}]
        # messages_input.insert(0, prompt[0])

        # Temporarily not using short-term memory
        messages_input = [{"role": "user", "content": user_input}]
        prompt = [{"role": "system", "content": self.system_prompt}]
        messages_input.insert(0, prompt[0])

        #TODO: Continue to add remaining functions / actions
        #TODO: Continue to compose "enums" with possible options for each function based on observations

        functions=[
                {
                    "name": "walk_to",
                    "description": "You will walk all the way to the destination",
                    "parameters": {
                        "type": "object",
                        "properties": {
                            "location_name": {
                                "type": "string",
                                "enum": ["Building1", "Building2", "Building3", "Building4", "Building5", "FreyaSwiftwind", "GarrickStormwind"],
                                "description": "Name of the player or place you would like to walk to",
                            }
                        },
                        "required": ["location_name"],
                    },
                },
                {
                    "name": "train",
                    "description": "You will train at a building you are currently nearby.",
                    "parameters": {
                        "type": "object",
                        "properties": {
                            "training_location_name": {
                                "type": "string",
                                "enum": ["Building1", "Building2", "Building3", "Building4", "Building5"],
                                "description": "Name of the building you would like to train at",
                            }
                        },
                        "required": ["training_location_name"],
                    },
                },
                {
                    "name": "talk_to",
                    "description": "You will start a conversation with nearby players",
                    "parameters": {
                        "type": "object",
                        "properties": {
                            "listener_id": {
                                "type": "string",
                                 "enum": ["FreyaSwiftwind", "GarrickStormwind"],
                                "description": "Name of the player you would like to converse with",
                            },
                            "message": {
                                "type": "string",
                                "description": "The text of the conversation between the two players. The player name precedes each piece of dialogue in the string.",
                            }
                        },
                        "required": ["listener_name", "message"],
                    },
                },
                {
                    "name": "pick_up_item",
                    "description": "The player can pickup nearby items",
                    "parameters": {
                        "type": "object",
                        "properties": {
                            "content": {
                                "type": "string",
                                "description": "Name of the item that the player would like to use",
                            },
                        },
                        "required": ["item_name"],
                    },
                },
                {
                    "name" : "trade",
                    "description" : "The player can trade with nearby players or shops",
                    "parameters": {
                        "type": "object",
                        "properties": {
                            "shop_name": {
                                "type": "string",
                                "description": "Name of the shop that the player would like to trade with",
                            },
                            "item_name": {
                                "type": "string",
                                "description": "Name of the item that the player would like to trade"
                            }
                        },
                        "required": ["shop_name", "item_name"]
                    }
                },

            ]

        print("MESSAGES INPUT :", messages_input)
        
        completion = openai.ChatCompletion.create(
            model="gpt-3.5-turbo-0613",
            temperature=temperature,
            frequency_penalty=frequency_penalty,
            presence_penalty=presence_penalty,
            messages=messages_input,
            functions=functions,
            function_call="auto"
        )

    
        chat_response = completion['choices'][0]['message']

        print("CHAT RESPONSE: ", chat_response)

        function_info = {}  
        response = ""  # Initialize response to an empty string

        if 'function_call' in completion.choices[0].message:
            function_info = completion.choices[0].message['function_call']
            response = function_info
            # print("FUNCTION INFO :", function_info)
        else:
            response = chat_response
        
        self.short_term_memory.append({"role": "assistant", "content": str(response)})

        # print("RESPONSE :", response)

        return response