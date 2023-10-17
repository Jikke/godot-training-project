extends Node2D

const TEAMSIZE : int = 4
var merc_preload = preload("res://scenes/mercenary.tscn")

var player_team : Array = []
var enemy_team : Array = []
var player_spawn_coordinates : Array = [Vector2(-72, -56), Vector2(-8, -56), Vector2(56, -56), Vector2(120, -56)]
var enemy_spawn_coordinates : Array = [Vector2(-72, 56), Vector2(-8, 56), Vector2(56, 56), Vector2(120, 56)]


# Called when the node enters the scene tree for the first time.
func _ready():
	if init_player_team() and init_enemy_team():
		$TurnManager.init()
		$TurnManager.start_battle()

func init_player_team() -> bool:
	player_team = Global.current_team
	player_team = player_team.slice(0, TEAMSIZE)
	var player_index = 0
	for merc in player_team:
		var texture_path = merc[0]
		var name = merc[1]
		var hitpoints = merc[3]
		var power = merc[4]
		var spawn_coordinate = player_spawn_coordinates[player_index]
		var new_merc = merc_preload.instantiate()
		new_merc.init(texture_path, name, hitpoints, power)
		new_merc.global_position = spawn_coordinate
		new_merc.add_to_group("player_team")
		$TurnManager.add_child(new_merc)
		new_merc.turn_done.connect($TurnManager._on_turn_done)
		player_index += 1
	if player_index > 0:
		return true
	return false

func init_enemy_team() -> bool:
	enemy_team = Global.shop_content
	enemy_team = enemy_team.slice(0, TEAMSIZE)
	var enemy_index = 0
	for merc in enemy_team:
		var texture_path = merc[0]
		var name = merc[1]
		var hitpoints = merc[3]
		var power = merc[4]
		var spawn_coordinate = enemy_spawn_coordinates[enemy_index]
		var new_merc = merc_preload.instantiate()
		new_merc.init(texture_path, name, hitpoints, power)
		new_merc.global_position = spawn_coordinate
		new_merc.add_to_group("enemy_team")
		$TurnManager.add_child(new_merc)
		new_merc.turn_done.connect($TurnManager._on_turn_done)
		enemy_index += 1
	if enemy_index > 0:
		return true
	return false

func move_camera(position : Vector2):
	$Camera2D.global_position = position


func _on_turn_manager_battle_ended():
	if $TurnManager.get_child(0):
		print($TurnManager.get_child(0).get_groups()[0], " has won!")
		Global.ui.hide_run_button()
		Global.goto_scene("res://scenes/game_control.tscn")
		Global.ui.show_money()
		
