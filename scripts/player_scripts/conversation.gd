extends RichTextLabel


var conversation = "Grimgar Stonebeard: Hey Lyra, how's it going? I see you have a Health Potion in your inventory. That's a useful item to have. Is there anything else you're looking to add?\\\\n\\\\nLyra Shadowheart: Hey Grimgar! Yeah, the Health Potion has come in handy. I'm actually looking to improve my combat skills. Do you have any weapons or armor that you're willing to trade?\\\\n\\\\nGrimgar Stonebeard: Well, I have an extra Iron Sword in my inventory. It's a pretty solid weapon. Would you be interested in trading your Health Potion for it?\\\\n\\\\nLyra Shadowheart: Hmm, I do need a better weapon. But I also want to make sure I have healing options. How about we do a trade where I give you my Health Potion and some gold coins for the Iron Sword?\\\\n\\\\nGrimgar Stonebeard: That sounds fair. How about you give me the Health Potion and 50 gold coins for the Iron Sword?\\\\n\\\\nLyra Shadowheart: Deal! Here's the Health Potion and 50 gold coins. I hope the Iron Sword will help me in battles.\\\\n\\\\nGrimgar Stonebeard: Perfect! Here's the Iron Sword. It should definitely improve your combat skills."

func display_conversation(conversation):
	var lines = conversation.split("\n")
	for line in lines:
		if line.begins_with("Grimgar Stonebeard"):
			append_text("[color=blue]" + line + "[/color]\n")
		elif line.begins_with("Lyra Shadowheart"):
			append_text("[color=red]" + line + "[/color]\n")
		else:
			append_text(line + "\n")
		self.scroll_to_line($RichTextLabel.get_line_count())
		await get_tree().create_timer(2.0).timeout  # Wait 2 seconds before the next line
		

