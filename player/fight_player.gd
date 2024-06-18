extends Node2D

@onready var tokens: Array = global.player_tokens
@onready var health: int = global.player_health

@onready var attack_region: Node2D = get_node("PlayerSprite/AttackRegion")

var currentTile: Array = [3,0]

@export var board: RingBoard

var can_move: bool = false

var button_width = 50
var button_height = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	snap_update_position()
	hide_attack()

func _input(event):
	if not can_move: return
	
	if event is InputEventMouseButton and event.pressed:
		var node: Node2D = board.get_closest_node(get_global_mouse_position())
		if node == null:
			return
			
		if abs(currentTile[0] - board.get_position_from_node(node)[0]) <= 1:
			if abs(currentTile[1] - board.get_position_from_node(node)[1]) <= 1:
				currentTile = board.get_position_from_node(node)
				global.player_moves_left -= 1
				print(global.player_moves_left)
				can_move = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_position()
	
func show_attack():
	attack_region.visible = true

func hide_attack():
	attack_region.visible = false

func update_position():
	var node_position = board.get_node_position(currentTile[0], currentTile[1])
	if node_position == Vector2(-256, -256):
		return
		
	global_position = lerp(global_position, node_position, 0.05)

func snap_update_position():
	var node_position = board.get_node_position(currentTile[0], currentTile[1])
	if node_position == Vector2(-256, -256):
		return
	global_position = node_position
