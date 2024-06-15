extends Node2D

var tokens: Array
var health: int
var currentNode: Array

@export var board: WorldBoard

@onready var camera = get_node("Camera2D")

# Called when the node enters the scene tree for the first time.
func _ready():
	set_current_node(0, 0)

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var node: Node2D = board.get_closest_node(get_global_mouse_position())
		if node == null:
			return
		
		var node_position: Array = board.get_position_from_node(node)
		
		if board.check_connection(currentNode, node_position):
			set_current_node(node_position[0], node_position[1])


func _process(delta):
	update_position()

func set_current_node(x: int, y: int):
	currentNode = [x, y]
	
func update_position():
	var node_position = board.get_node_position(currentNode[0], currentNode[1])
	if node_position == Vector2(-256, -256):
		return
		
	global_position = lerp(global_position, node_position, 0.1)
