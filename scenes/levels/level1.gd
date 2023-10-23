extends Node2D

const TEAMSIZE : int = 4
var merc_preload = preload("res://scenes/mercenary.tscn")
var enemy_preload = preload("res://scenes/enemy.tscn")

var player_team : Array = []
var enemy_team : Array = []
var player_spawn_coordinates : Array = [Vector2(-5, -4), Vector2(-1, -4), Vector2(3, -4), Vector2(7, -4)]
var enemy_spawn_coordinates : Array = [Vector2(-5, 3), Vector2(-1, 3), Vector2(3, 3), Vector2(7, 3)]
@onready var turn_manager = $TurnManager
@onready var tilemap = $Ground/TileMap
var astar_grid = AStarGrid2D.new()



# Called when the node enters the scene tree for the first time.
func _ready():
	init_astar_grid()
	if init_player_team() and init_enemy_team():
		turn_manager.init()
		turn_manager.start_battle()
#		print(get_astar_path(Vector2(-5, 3), Vector2(-5, -4)))

func init_player_team() -> bool:
	player_team = Global.current_team
	player_team = player_team.slice(0, TEAMSIZE)
	var player_index = 0
	for merc in player_team:
		var texture_path = merc[0]
		var name = merc[1]
		var max_health = merc[3]
		var power = merc[4]
		var spawn_coordinate = player_spawn_coordinates[player_index]
		var new_merc = merc_preload.instantiate()
		new_merc.init(texture_path, name, max_health, power)
		new_merc.global_position = astar_grid.get_point_position(spawn_coordinate)
		new_merc.add_to_group("player_team")
		turn_manager.add_child(new_merc)
		new_merc.turn_done.connect(turn_manager._on_turn_done)
		new_merc.colliders_found.connect(Global.ui._on_colliders_found)
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
		var max_health = merc[3]
		var power = merc[4]
		var spawn_coordinate = enemy_spawn_coordinates[enemy_index]
		var new_enemy = enemy_preload.instantiate()
		new_enemy.init(texture_path, name, max_health, power)
		new_enemy.modulate_enemy_sprite()
		new_enemy.global_position = astar_grid.get_point_position(spawn_coordinate)
		new_enemy.add_to_group("enemy_team")
		turn_manager.add_child(new_enemy)
		new_enemy.turn_done.connect(turn_manager._on_turn_done)
		new_enemy.colliders_found.connect(Global.ui._on_colliders_found)
		enemy_index += 1
	if enemy_index > 0:
		return true
	return false

func init_astar_grid():
	astar_grid.region = Rect2i(-320, -320, 656, 656)
	astar_grid.cell_size = Vector2(16, 16)
	astar_grid.update()

func get_astar_path(from : Vector2, to : Vector2):
	var from_as_cell = tilemap.local_to_map(from)
	var to_as_cell = tilemap.local_to_map(to)
	return astar_grid.get_point_path(from_as_cell, to_as_cell)

func move_camera(position : Vector2):
	$Camera2D.global_position = position

func _on_turn_manager_battle_ended():
	if turn_manager.get_child(0):
		print(turn_manager.get_child(0).get_groups()[0], " has won!")
		Global.ui.hide_run_button()
		Global.ui.remove_colliders()
		Global.goto_scene("res://scenes/game_control.tscn")
		Global.ui.show_money()

