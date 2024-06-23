extends Node2D

@onready var sprite = get_node("Sprite")
const sprite_width = 150
const sprite_height = 75

@onready var timer = get_node("Timer")

@onready var selector = get_parent().get_node("Selector")
@onready var move_area = get_parent().get_node("DieAreaMove")
@onready var attack_area = get_parent().get_node("DieAreaAttack")
@onready var block_area = get_parent().get_node("DieAreaBlock")

@onready var go_button = get_parent().get_node("GoButton")

enum DiceArea {
	MOVE,
	ATTACK,
	BLOCK
}

const last_frame = 7
var current_frame = 0

var result = -1
var current_area: DiceArea

var initial_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	initial_position = global_position
	
func reset():
	global_position = initial_position
	result = -1
	current_area
	
func start_spin():
	timer.wait_time = 0.001
	timer.start()
	
	result = -1
	
	global.move_picked = false
	global.attack_picked = false
	global.block_picked = false
	
	# Set to random starting orientation
	sprite.frame = randi_range(0, 7)
	if(sprite.frame % 2 == 1):
		sprite.frame -= 1
	
func spin():
	animate_spin()
	
	timer.wait_time += randf_range(0.0, 0.049)
	if timer.wait_time > randf_range(0.3, 0.5):
		stop_spin()
		if sprite.frame % 2 == 1:
			sprite.frame -= 1
			
		send_result()
	
func stop_spin():
	timer.stop()

func send_result():
	result = (sprite.frame / 2 ) + 1

func animate_spin():
	if current_frame < last_frame:
		current_frame += 1
	else:
		current_frame = 0
	
	sprite.frame = current_frame

# Spin Update Timer
func _on_timer_timeout():
	spin()

func _on_roll_button_roll_clicked():
	start_spin()
	
func _input(event):
	if not get_parent().visible: return
	if result == -1: return
	
	# Select Die
	if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_position = get_global_mouse_position()
	
		var distance_x = abs(global_position.x - mouse_position.x)
		var distance_y = abs(global_position.y - mouse_position.y)
		
		if distance_x < (sprite_width / 2) and distance_y < (sprite_height / 2):
			click_event()
	
	# Move 
	if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		if selector.global_position.distance_to(global_position) < 0.1:
			var mouse_position = get_global_mouse_position()
			
			var distance_x_move = abs(move_area.global_position.x - mouse_position.x)
			var distance_y_move = abs(move_area.global_position.y - mouse_position.y)
			
			var distance_x_attack = abs(attack_area.global_position.x - mouse_position.x)
			var distance_y_attack = abs(attack_area.global_position.y - mouse_position.y)
			
			var distance_x_block = abs(block_area.global_position.x - mouse_position.x)
			var distance_y_block = abs(block_area.global_position.y - mouse_position.y)
			
			if distance_x_move < (sprite_width / 2) and distance_y_move < (sprite_height / 2):
				move_to(DiceArea.MOVE)
			
			if distance_x_attack < (sprite_width / 2) and distance_y_attack < (sprite_height / 2):
				move_to(DiceArea.ATTACK)
				
			if distance_x_block < (sprite_width / 2) and distance_y_block < (sprite_height / 2):
				move_to(DiceArea.BLOCK)

func click_event():
	selector.global_position = global_position

func move_to(area: DiceArea):
	# Show Go button at this point
	go_button.visible = true
	
	if current_area == DiceArea.MOVE:
		global.move_picked = false
		#global.player_moves_left = -1
	
	if current_area == DiceArea.ATTACK:
		global.attack_picked = false
		#global.player_attacks_left = -1
		
	if current_area == DiceArea.BLOCK:
		global.block_picked = false
		#global.player_blocks_left = -1
	
	if area == DiceArea.MOVE:
		if global.move_picked == true: return
		global_position = move_area.global_position
		global.move_picked = true
		global.player_moves_left = result
		
	if area == DiceArea.ATTACK:
		if global.attack_picked == true: return
		global_position = attack_area.global_position
		global.attack_picked = true
		global.player_attacks_left = result
		
	if area == DiceArea.BLOCK:
		if global.block_picked == true: return
		global_position = block_area.global_position
		global.block_picked = true
		global.player_blocks_left = result

	current_area = area
	selector.global_position = global_position
