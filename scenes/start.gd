extends Node2D

const sprite_width = 200
const sprite_height = 75

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_position = get_global_mouse_position()
	
		var distance_x = abs($Background/Button.global_position.x - mouse_position.x)
		var distance_y = abs($Background/Button.global_position.y - mouse_position.y)
		
		if distance_x < (sprite_width / 2) and distance_y < (sprite_height / 2):
			get_tree().change_scene_to_file("res://scenes/world_board.tscn")
