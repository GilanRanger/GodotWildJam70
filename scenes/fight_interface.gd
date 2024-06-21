extends CanvasLayer
class_name FightInterface

var start_turn: bool = false

@onready var enemy_health_bar = get_node("EnemyHealthDisplay")
@onready var player_health_bar = get_node("PlayerHealthDisplay")
@onready var tokens_panel = get_node("TokensDisplay")
@onready var dice_display = get_node("DiceDisplay")
@onready var message_display = get_node("MessageDisplay")

@onready var victory_screen = get_node("PlayerVictoryScreen")
@onready var game_over_screen = get_node("PlayerGameOverScreen")

# Called when the node enters the scene tree for the first time.
func _ready():
	dice_display.visible = false
	message_display.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_go_button_go_clicked():
	start_turn = true

func reset_dice():
	dice_display.get_node("Die1").reset()
	dice_display.get_node("Die2").reset()
	dice_display.get_node("Die3").reset()
	
	global.player_moves_left = -1
	global.player_attacks_left = -1
	global.player_blocks_left = -1
	
	dice_display.get_node("GoButton").visible = false
	dice_display.get_node("RollButton").visible = true

func update_health(player_health_values: Array, enemy_health_values: Array):
	var player_max = player_health_values[1]
	var player_health = player_health_values[0]
	
	var enemy_max = enemy_health_values[1]
	var enemy_health = enemy_health_values[0]
	
	player_health_bar.current_health = player_health
	player_health_bar.max_health = player_max
	
	enemy_health_bar.current_health = enemy_health
	enemy_health_bar.max_health = enemy_max
	
func setup_health(player_max_health: int, enemy_max_health: int):
	player_health_bar.set_health(player_max_health)
	enemy_health_bar.set_health(enemy_max_health)

func setup_names(player_name: String, enemy_name: String):
	player_health_bar.set_label_name(player_name)
	enemy_health_bar.set_label_name(enemy_name)
