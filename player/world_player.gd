extends Node2D

@onready var tokens: Array = global.player_tokens
@onready var health: int = global.player_health

var currentNode: Array

@export var board: WorldBoard

@onready var camera = get_node("Camera2D")

func _ready():
	set_current_node(1, 3)
	snap_update_position()

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var node: Node2D = board.get_closest_node(get_global_mouse_position())
		if node == null:
			return
		
		var node_position: Array = board.get_position_from_node(node)
		
		if board.check_connection(currentNode, node_position):
			set_current_node(node_position[0], node_position[1])
			await get_tree().create_timer(1.0).timeout
			attempt_start_fight()


func _process(delta):
	update_position()

func set_current_node(x: int, y: int):
	currentNode = [x, y]
	
func attempt_start_fight():
	var enemy = board.get_enemy_at(currentNode[0], currentNode[1])
	if enemy == null: return
	
	print("Starting fight with: ", enemy.name)
	# Switch to fight scene
	
func update_position():
	var node_position = board.get_node_position(currentNode[0], currentNode[1])
	if node_position == Vector2(-256, -256):
		return
		
	global_position = lerp(global_position, node_position, 0.05)

func snap_update_position():
	var node_position = board.get_node_position(currentNode[0], currentNode[1])
	if node_position == Vector2(-256, -256):
		return
	global_position = node_position
