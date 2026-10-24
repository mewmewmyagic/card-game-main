#this is an autoload
extends Node

var queue: Array[BattleAction]

func push_back(action: BattleAction) -> void:
	queue.push_back(action)


func drain() -> void:
	while not queue.is_empty():
		var action: BattleAction = queue.pop_front()
		await action.execute()
