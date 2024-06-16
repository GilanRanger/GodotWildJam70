extends Node2D
class_name WorldEnemy

@export var homeNode: Array 
@export var board: WorldBoard

# Called when the node enters the scene tree for the first time.
func _ready():
	if homeNode != null:
		global_position = board.get_node_position(homeNode[0], homeNode[1])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
