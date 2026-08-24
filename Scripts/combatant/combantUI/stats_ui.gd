extends HBoxContainer
class_name StatsUI

@onready var shield: HBoxContainer = $shield
@onready var shield_label: Label = $%ShieldLabel

@onready var health: HBoxContainer = $health
@onready var health_label: Label = $%HealthLabel

func update_stats(stats: Stats) -> void:
	shield_label.text = str(stats.shield)
	health_label.text = str(stats.health)
