extends Node

class_name CurrencyManager

var balance : int = 0

func increase_balance(amount : int) -> void:
	balance += amount

func decrease_balance(amount : int) -> bool:
	if balance >= amount:
		balance -= amount
		return true
	else:
		return false
		
func get_balance() -> int:
	return balance
