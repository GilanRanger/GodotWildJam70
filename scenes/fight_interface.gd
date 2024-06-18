extends CanvasLayer
class_name FightInterface

var start_turn: bool = false

@onready var enemy_health_bar = get_node("EnemyHealthDisplay")
@onready var player_health_bar = get_node("PlayerHealthDisplay")
@onready var tokens_panel = get_node("TokensDisplay")
@onready var dice_display = get_node("DiceDisplay")
@onready var message_display = get_node("MessageDisplay")

# Called when the node enters the scene tree for the first time.
func _ready():
	dice_display.visible = false
	message_display.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_go_button_go_clicked():
	start_turn = true
