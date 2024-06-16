extends Node2D
class_name RingBoard

@onready var grid_nodes: Array = get_node("GridNodes").get_children()
@onready var enemy = get_node("Enemy")
@onready var fight_player = get_node("Player/FightPlayer")
@onready var interface: FightInterface = get_node("UI/CanvasLayer")

# Fight States
enum FightState {
	WAIT,
	ROLL,
	DICE_PICK,
	MOVE_PLAYER,
	MOVE_ENEMY,
	ATTACK_PLAYER,
	ATTACK_ENEMY,
	PLAYER_WIN,
	PLAYER_LOSE
}

var fight_state = FightState.WAIT

func get_node_position(x: int, y: int) -> Vector2:
	var node_name = str(x) + "," + str(y)
	var node = (get_node("GridNodes/" + node_name) as Node2D)
	
	if node == null:
		return Vector2(-256, -256)
		
	return node.global_position

func get_position_from_node(node: Node2D) -> Array:
	var parts = node.name.split(",")
	if parts.size() != 2:
		print("Invalid node name format.")
		return []
	# Convert the strings to integers
	var x = int(parts[0])
	var y = int(parts[1])
	# Return the result as an array of integers
	return [x, y]
