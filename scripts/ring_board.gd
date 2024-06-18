extends Node2D
class_name RingBoard

@onready var grid_nodes: Array = get_node("GridNodes").get_children()
@onready var enemy = get_node("Enemy").get_child(0)
@onready var fight_player = get_node("Player/FightPlayer")
@onready var interface: FightInterface = get_node("UI/CanvasLayer")

# Fight States
enum FightState {
	WAIT,
	ROLL,
	MOVE_PLAYER,
	MOVE_ENEMY,
	ATTACK_PLAYER,
	ATTACK_ENEMY,
	PLAYER_WIN,
	PLAYER_LOSE
}

var fight_state = FightState.WAIT

func _ready():
	await get_tree().create_timer(2.0).timeout
	set_fight_state(FightState.ROLL)
	
func _process(delta):
	if interface.start_turn:
		set_fight_state(FightState.MOVE_PLAYER)
		interface.start_turn = false
		
	if global.player_moves_left > -1:
		if not fight_player.can_move and not interface.dice_display.visible:
			set_fight_state(FightState.MOVE_ENEMY)

func set_fight_state(state: FightState):
	fight_state = state
	
	if state == FightState.ROLL:
		interface.dice_display.visible = true
		
		enemy.start_new_turn()
		
	elif state == FightState.MOVE_PLAYER:
		interface.dice_display.visible = false
		
		if(global.player_moves_left == -1):
			set_fight_state(FightState.MOVE_ENEMY)
		else:
			fight_player.can_move = true
		
		interface.message_display.visible = true
		interface.message_display.set_message("Click a tile to move. Moves left: " + str(global.player_moves_left))
		
	elif state == FightState.MOVE_ENEMY:
		if global.player_moves_left > 0:
			set_fight_state(FightState.MOVE_PLAYER)
		else:
			global.player_moves_left = -1
		
		enemy.move(fight_player.currentTile)
		
		if global.player_moves_left <= 0 and enemy.moves_left > 0:
			await get_tree().create_timer(1.0).timeout
			set_fight_state(FightState.MOVE_ENEMY)
		elif global.player_moves_left <= 0:
			set_fight_state(FightState.ATTACK_PLAYER)
		
	elif state == FightState.ATTACK_PLAYER:
		await get_tree().create_timer(1.0).timeout
		
		interface.message_display.set_message("Click to attack for " + str(global.player_attacks_left) + " damage.")
		fight_player.show_attack()
		
	elif state == FightState.ATTACK_ENEMY:
		await get_tree().create_timer(2.0).timeout
		
		fight_player.hide_attack()
		enemy.show_attack()
		
		pass
	elif state == FightState.PLAYER_WIN:
		pass
	elif state == FightState.PLAYER_LOSE:
		pass

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
	
func get_closest_node(global_point: Vector2) -> Node2D:
	var max_distance = 30
	
	for node in get_node("GridNodes").get_children():
		node = node as Node2D
		if (abs(node.global_position.x - global_point.x) < 30 
			and abs(node.global_position.y - global_point.y) < 30):
				return node
				
	return null
