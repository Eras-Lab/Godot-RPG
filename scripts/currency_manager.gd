extends Node

class_name CurrencyManager

var gold : int = 0

func add_gold(amount : int) -> void:
	gold += amount

func subtract_gold(amount : int) -> bool:
	if gold >= amount:
		gold -= amount
		return true
	else:
		return false

