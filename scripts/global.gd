extends Node

var player_health = 10
var player_tokens = []

var player_world_position = [1, 3]

var move_picked: bool = false
var attack_picked: bool = false
var block_picked: bool = false

var player_moves_left = -1
var player_attacks_left = -1
var player_blocks_left = -1

enum Fight {
	FAD_FELEN,
	BWGAN,
	GIANT,
	GWIBER
}

var selected_fight = Fight.FAD_FELEN

var fad_felen_alive = true
var bwgan_alive = true
var giant_alive = true
var gwiber_alive = true
