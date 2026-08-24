extends Control
class_name StaminaUI

@onready var label: Label = $Label
var player_stats = CombatantStats
func bind(stats: CombatantStats):
	player_stats = stats
	stats.stamina_changed.connect(_on_stamina_changed)
	_refresh()
	
func _on_stamina_changed(_new_stamina: int) -> void:
	_refresh()
	
func _refresh() -> void:
	label.text = "%d / %d" % [player_stats.stamina, player_stats.max_stamina]
	
