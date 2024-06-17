extends Node2D

@onready var text_label = get_node("Message")

func set_message(message: String):
	text_label.text = message
