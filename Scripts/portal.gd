extends Node2D

@export var destination:String

func _on_area_2d_body_entered(_body: Node2D) -> void:
	get_tree().change_scene_to_file.call_deferred("res://Levels/"+destination)
	print("Loading level: "+destination)
