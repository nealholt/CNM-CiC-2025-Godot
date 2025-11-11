extends Node

# Script used for managing game states


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func load_level(level_path: String):
	get_tree().change_scene_to_file(level_path)
	print("Loading level: level_path")

func _unhandled_input(event):
	if event.is_action_pressed("load_next_level"):
		load_level("res://Levels/Level01_Tiles_demo/level_1_tileset_demo.tscn")
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
