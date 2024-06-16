extends Node2D

@onready var tokens: Array = global.player_tokens
@onready var health: int = global.player_health

var currentTile: Array = [3,0]

@export var board: RingBoard

# Called when the node enters the scene tree for the first time.
func _ready():
	snap_update_position()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_position()

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
