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
	GWYLLION,
	GIANT,
	GWIBER,
	
	CWN_ANNWN,
	BULL,
	BWGAN,
	
	COCKATRICE,
	PWCA,
	
	RED_DRAGON
}

var selected_fight = Fight.FAD_FELEN

var fad_felen_alive = true
var gwyllion_alive = true
var giant_alive = true
var gwiber_alive = true

var cwn_annwn_alive = true
var bull_alive = true
var bwgan_alive = true

var cockatrice_alive = true
var pwca_alive = true

var red_dragon_alive = true
