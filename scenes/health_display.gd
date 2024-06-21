extends Node2D

@onready var overlay = get_node("Overlay")
@onready var label = get_node("Label")
@onready var healthLabel = get_node("HealthLabel")

var current_health: int
var max_health: int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func set_label_name(label_name: String):
	label.text = label_name
	
func set_health(health: int):
	current_health = health
	max_health = health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(current_health < 0): current_health = 0
	healthLabel.text = str(current_health) + "/" + str(max_health)
	
	var health_percent: float = float(current_health) / float(max_health) 
	
	if health_percent > 0.96:
		overlay.frame = 0
		return
	if health_percent > 0.88:
		overlay.frame = 1
		return
	if health_percent > 0.64:
		overlay.frame = 2
		return
	if health_percent > 0.52:
		overlay.frame = 3
		return
	if health_percent > 0.40:
		overlay.frame = 4
		return
	if health_percent > 0.30:
		overlay.frame = 5
		return
	if health_percent > 0.20:
		overlay.frame = 6
		return
	if health_percent > 0.10:
		overlay.frame = 7
		return
	if health_percent == 0:
		overlay.visible = false
