extends Area2D

#DO NOT circular dependency packed scenes
@export_file("*.tscn") var battle_scene_path: String

func _on_body_entered(body: Node) -> void:
	if not body.is_in_group("player_overworld"):
		return
		
	SceneLoader.load_scene(battle_scene_path)
