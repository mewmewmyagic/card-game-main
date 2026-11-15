class_name CombatantData
extends Resource

@export var stats: CombatantStats
@export var appearance: CombatantSpriteResource
@export var ai_behaviour: CombatantAIBase = null
@export var combatant_name: String
@export var position: Vector2
@export var scale := Vector2(0.2, 0.2)
