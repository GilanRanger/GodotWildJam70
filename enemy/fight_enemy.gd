extends Node2D
class_name FightEnemy

var currentTile: Array = [3,5]

@export var health: int
@export var board: RingBoard

@export var offset: Array = [0, 0]
@export var total_moves: int = 2

@export var attack_regions = [[0,0]]

@onready var attack_region: Node2D = get_node("EnemySprite/AttackRegion")

var moves_left = total_moves

# Called when the node enters the scene tree for the first time.
func _ready():
	snap_update_position()
	hide_attack()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_position()

func start_new_turn():
	moves_left = total_moves

func show_attack():
	attack_region.visible = true

func hide_attack():
	attack_region.visible = false

func move(player_position: Array):
	var offset_position = [0,0]
	offset_position[0] = player_position[0] + offset[0]
	offset_position[1] = player_position[1] + offset[1]
	
	if moves_left < 1:
		return
	
	var row_move = clampi(offset_position[0] - currentTile[0], -1, 1)
	var column_move = clampi(offset_position[1] - currentTile[1], -1, 1)
	
	if  6 >= (currentTile[0] + row_move) and (currentTile[0] + row_move) >= 0:
		currentTile[0] += row_move
	if  6 >= (currentTile[1] + column_move) and (currentTile[1] + column_move) >= 0:
		currentTile[1] += column_move
		
	moves_left -= 1

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
