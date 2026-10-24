#this is an autoload
extends Node

signal drained

var queue: Array[BattleAction]
var draining: bool = false

func push_back(action: BattleAction) -> void:
	queue.push_back(action)


func drain() -> void:
	if draining:
		await drained
	
	draining = true
	while not queue.is_empty():
		var action: BattleAction = queue.pop_front()
		await action.execute()
		
	draining = false
	drained.emit()
