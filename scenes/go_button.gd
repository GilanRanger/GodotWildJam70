extends Node2D

@onready var sprite = get_node("Sprite")

var sprite_width = 150
var sprite_height = 75

signal go_clicked

func _ready():
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not visible: return
	
	var mouse_position = get_global_mouse_position()
	
	var distance_x = abs(global_position.x - mouse_position.x)
	var distance_y = abs(global_position.y - mouse_position.y)
	
	if distance_x < (sprite_width / 2) and distance_y < (sprite_height / 2):
		set_hover_texture()
	else:
		set_defualt_texture()
		
func _input(event):
	if not visible: return
	
	if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_position = get_global_mouse_position()
	
		var distance_x = abs(global_position.x - mouse_position.x)
		var distance_y = abs(global_position.y - mouse_position.y)
		
		if distance_x < (sprite_width / 2) and distance_y < (sprite_height / 2):
			click_event()

func click_event():
	go_clicked.emit()
	

func set_hover_texture():
	sprite.frame = 1
	
func set_defualt_texture():
	sprite.frame = 0
