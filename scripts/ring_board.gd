extends Node2D
class_name RingBoard

@onready var grid_nodes: Array = get_node("GridNodes").get_children()
var enemy: FightEnemy
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
	if global.selected_fight == global.Fight.FAD_FELEN:
		enemy = load("res://enemy/fight_fed_felen.tscn").instantiate()
	if global.selected_fight == global.Fight.GIANT:
		enemy = load("res://enemy/fight_giant.tscn").instantiate()
	if global.selected_fight == global.Fight.GWYLLION:
		enemy = load("res://enemy/fight_gwyllion.tscn").instantiate()
	if global.selected_fight == global.Fight.GWIBER:
		enemy = load("res://enemy/fight_gwiber.tscn").instantiate()
	
	if global.selected_fight == global.Fight.CWN_ANNWN:
		enemy = load("res://enemy/fight_cwn_annwn.tscn").instantiate()
	if global.selected_fight == global.Fight.BWGAN:
		enemy = load("res://enemy/fight_bwgan.tscn").instantiate()
	if global.selected_fight == global.Fight.BULL:
		enemy = load("res://enemy/fight_bull.tscn").instantiate()
	
	if global.selected_fight == global.Fight.COCKATRICE:
		enemy = load("res://enemy/fight_cockatrice.tscn").instantiate()
	if global.selected_fight == global.Fight.PWCA:
		enemy = load("res://enemy/fight_pwca.tscn").instantiate()
		
	if global.selected_fight == global.Fight.RED_DRAGON:
		enemy = load("res://enemy/fight_red_dragon.tscn").instantiate()
	
	enemy.board = self
	get_node("Enemy").add_child(enemy)
	
	interface.setup_health(global.player_health, enemy.health)
	interface.setup_names("Pryderi", enemy.enemy_name)
	
	set_fight_state(FightState.ROLL)
	
func _process(delta):
	interface.update_health([fight_player.health, global.player_health], [enemy.health, enemy.max_health])
	
	if interface.start_turn:
		set_fight_state(FightState.MOVE_PLAYER)
		interface.start_turn = false
		
	if global.player_moves_left > -1:
		if not fight_player.can_move and not interface.dice_display.visible:
			set_fight_state(FightState.MOVE_ENEMY)

func set_fight_state(state: FightState):
	fight_state = state
	
	if state == FightState.ROLL:
		await get_tree().create_timer(2.0).timeout
		
		interface.message_display.visible = true
		interface.message_display.set_message("Roll and pick!")
		
		enemy.hide_attack()
		interface.reset_dice()
		interface.dice_display.visible = true
		
		enemy.start_new_turn()
		
	elif state == FightState.MOVE_PLAYER:
		interface.dice_display.visible = false
		
		interface.message_display.visible = true
		
		if(global.player_moves_left == -1):
			set_fight_state(FightState.MOVE_ENEMY)
		else:
			fight_player.can_move = true
		
		interface.message_display.set_message("Click a tile to move. Moves left: " + str(global.player_moves_left))
		
	elif state == FightState.MOVE_ENEMY:
		interface.message_display.set_message("Click a tile to move. Moves left: 0")
		
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
		await get_tree().create_timer(2.0).timeout
		
		var player_attack = global.player_attacks_left
		if player_attack < 0: player_attack = 0
		interface.message_display.set_message("Attacking for " + str(player_attack) + " damage.")
		fight_player.show_attack()
		
		fight_player.attack(enemy)
		
		set_fight_state(FightState.ATTACK_ENEMY)
		
	elif state == FightState.ATTACK_ENEMY:
		await get_tree().create_timer(2.0).timeout
		
		fight_player.hide_attack()
		enemy.show_attack()
		
		var enemy_attack_damage = enemy.get_attack_damage()
		
		var block = global.player_blocks_left
		if block < 0: block = 0
		interface.message_display.set_message("Enemy attack of " + str(enemy_attack_damage) 
			+ " with player blocking " + str(block) + ".")
		
		var result_attack = enemy_attack_damage - block
		if result_attack < 0: result_attack = 0
		var player_health = await enemy.attack(result_attack, fight_player)
			
		if enemy.health <= 0:
			set_fight_state(FightState.PLAYER_WIN)
		elif player_health <= 0:
			set_fight_state(FightState.PLAYER_LOSE)
		else:
			set_fight_state(FightState.ROLL)
		
		pass
	elif state == FightState.PLAYER_WIN:
		interface.victory_screen.visible = true
		
		if global.selected_fight == global.Fight.FAD_FELEN:
			global.fad_felen_alive = false
		if global.selected_fight == global.Fight.GWYLLION:
			global.gwyllion_alive = false
		if global.selected_fight == global.Fight.GIANT:
			global.giant_alive = false
		if global.selected_fight == global.Fight.GWIBER:
			global.gwiber_alive = false
		if global.selected_fight == global.Fight.CWN_ANNWN:
			global.cwn_annwn_alive = false
		if global.selected_fight == global.Fight.BWGAN:
			global.bwgan_alive = false
		if global.selected_fight == global.Fight.BULL:
			global.bull_alive = false
		if global.selected_fight == global.Fight.COCKATRICE:
			global.cockatrice_alive = false
		if global.selected_fight == global.Fight.PWCA:
			global.pwca_alive = false
		if global.selected_fight == global.Fight.RED_DRAGON:
			global.red_dragon_alive = false
			
		global.player_health += 2
		
		await get_tree().create_timer(2.0).timeout
		# return to world
		get_tree().change_scene_to_file("res://scenes/world_board.tscn")
	elif state == FightState.PLAYER_LOSE:
		interface.game_over_screen.visible = true

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
