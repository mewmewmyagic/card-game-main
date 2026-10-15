extends Control
class_name HandDisplay

@onready var color: ColorRect = $Visuals/Color
@onready var stam_label: Label = $Visuals/Stam
@onready var rc_label: Label = $Visuals/Rc
@onready var name_label: Label = $Visuals/Name
@onready var visuals: Node = $Visuals

#temp
@export var card: Card
@export var owner_combatant: Combatant

func _ready() -> void:
	pass
