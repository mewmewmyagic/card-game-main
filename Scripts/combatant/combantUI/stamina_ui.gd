extends Control
class_name StaminaUI

@onready var label: Label = $Label
var player_stats: CombatantStats
func bind(stats: CombatantStats):
	unbind()
	player_stats = stats
	player_stats.stamina_changed.connect(_on_stamina_changed)
	_refresh()

func unbind():
	if player_stats and player_stats.stamina_changed.is_connected(_on_stamina_changed):
		player_stats.stamina_changed.disconnect(_on_stamina_changed)
	
func _on_stamina_changed(_new_stamina: int) -> void:
	_refresh()
	
func _refresh() -> void:
	label.text = "%d / %d" % [player_stats.stamina, player_stats.max_stamina]
	
