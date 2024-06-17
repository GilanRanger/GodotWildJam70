extends Node2D

const MIN_SIZE = 0.95
const MAX_SIZE = 1.05

var growing: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if growing:
		scale.x += 0.15 * delta
		scale.y += 0.15 * delta
	else:
		scale.x -= 0.15 * delta
		scale.y -= 0.15 * delta
		
	if abs(scale.x - MIN_SIZE) < 0.01:
		growing = true
	if abs(scale.x - MAX_SIZE) < 0.01:
		growing = false
