extends Node2D

@onready var sprite = get_node("Sprite")
@onready var timer = get_node("Timer")

const last_frame = 7
var current_frame = 0

var rng = RandomNumberGenerator.new()

var result = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func start_spin():
	timer.wait_time = 0.001
	timer.start()
	
	result = -1
	
	# Set to random starting orientation
	sprite.frame = randi_range(0, 7)
	if(sprite.frame % 2 == 1):
		sprite.frame -= 1
	
func spin():
	animate_spin()
	
	timer.wait_time += rng.randf_range(0.05, 0.025)
	if timer.wait_time > rng.randf_range(0.45, 0.55):
		stop_spin()
		if sprite.frame % 2 == 1:
			sprite.frame -= 1
			
		send_result()
	
func stop_spin():
	timer.stop()

func send_result():
	result = (sprite.frame / 2 ) + 1
	print(result)

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
