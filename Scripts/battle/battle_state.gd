class_name BattleState
extends Node

const ALLY_START_X = -150.0
const ENEMY_START_X = 150.0
const TEAM_SPACING = 75.0
const START_Y = 25.0

var allies: Array[Combatant] = []
var enemies: Array[Combatant] = []
var neutral: Array[Combatant] = []

var current_turn: CombatantTurn
var round_number: int = 0

const COMBATANT_SCENE := preload("res://scenes/Combatant.tscn")

func setup_actors(data: BattleData) -> void:
	allies = _spawn_ally_team(data.allies)
	enemies = _spawn_enemy_team(data.enemies)
	neutral = _spawn_team(data.neutral)

func _spawn_team(team_data: Array[CombatantData]) -> Array[Combatant]:
	var team: Array[Combatant] = []
	for d in team_data:
		var c := COMBATANT_SCENE.instantiate() as Combatant
		c.setup(d)   
		team.append(c)
		add_child(c)
	return team
	
func _spawn_ally_team(team_data: Array[CombatantData]) -> Array[Combatant]:
	var team: Array[Combatant] = []

	for i in range(team_data.size()):
		var c := COMBATANT_SCENE.instantiate() as Combatant
		c.setup(team_data[i])
		add_child(c)

		c.position = Vector2(
			ALLY_START_X - i * TEAM_SPACING,
			START_Y
		)
		c.sprite_2d.scale.x *= -1
		team.append(c)

	return team


func _spawn_enemy_team(team_data: Array[CombatantData]) -> Array[Combatant]:
	var team: Array[Combatant] = []

	for i in range(team_data.size()):
		var c := COMBATANT_SCENE.instantiate() as Combatant
		c.setup(team_data[i])
		add_child(c)

		c.position = Vector2(
			ENEMY_START_X + i * TEAM_SPACING,
			START_Y
		)

		team.append(c)

	return team

func literally_all_combatants() -> Array[Combatant]:
	return allies + enemies + neutral

func all_combatants() -> Array[Combatant]:          # who counts for win/lose and who ALL hits
	return allies + enemies

func opposing_team(c: Combatant) -> Array[Combatant]:
	if c in allies: return enemies
	if c in enemies: return allies
	
	push_error("Not found opposing team")
	return all_combatants()

func same_team(c: Combatant) -> Array[Combatant]:
	if c in allies: return allies
	if c in enemies: return enemies
	
	push_error("Not found same team")
	return neutral

func alive(team: Array[Combatant]) -> Array[Combatant]:
	var result: Array[Combatant] = []
	for c in team:
		if not c.is_dead:
			result.append(c)
	return result

func battle_is_over() -> bool:
	return alive(allies).is_empty() or alive(enemies).is_empty()
		
func add_recovery_time_to_current(amount: int) -> void:
		current_turn.recovery_time += amount
	#turn_order_changed.emit()
