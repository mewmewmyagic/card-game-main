
extends Control
class_name CombatantStatsUI

@onready var shield: HBoxContainer = $HealthBar/shield
@onready var shield_value: Label = $HealthBar/shield/ShieldValue
@onready var shield_bar: ProgressBar = $ShieldBar

@onready var health: HBoxContainer = $HealthBar/health
@onready var health_bar: ProgressBar = $HealthBar
@onready var health_value: Label = $HealthBar/health/HealthValue

var stats: Stats
var _bar_tween: Tween

func bind(new_stats: Stats) -> void:
	stats = new_stats
	stats.stats_changed.connect(_on_stats_changed)
	_refresh(true)

func _on_stats_changed() -> void:
	_refresh(false)

func _refresh(shouldnt_tween: bool) -> void:
	health_bar.max_value = stats.max_health
	shield_bar.max_value = stats.max_health
	health_value.text = "%d / %d" % [stats.health, stats.max_health]
	shield_value.text = str(stats.shield)
	shield.visible = stats.shield > 0

	if shouldnt_tween:
		health_bar.value = stats.health
		shield_bar.value = stats.shield
		return

	if _bar_tween and _bar_tween.is_valid():
		_bar_tween.kill()
	_bar_tween = create_tween()
	_bar_tween.set_trans(Tween.TRANS_SINE)
	_bar_tween.tween_property(shield_bar, "value", stats.shield, 0.25)
	_bar_tween.tween_property(health_bar, "value", stats.health, 0.25)
