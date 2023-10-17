extends Node2D

class_name TurnManager

var active_character

func init():
	active_character = get_child(0)

func update_next_active_character():
	var new_index : int = (active_character.get_index() + 1) % get_child_count()
	active_character = get_child(new_index)

func _on_turn_done():
	update_next_active_character()
	var active_char_pos = active_character.get_pos()
	$"..".move_camera(active_char_pos)
	active_character.play_turn()

func start_battle():
	var first_char_pos = active_character.get_pos()
	$"..".move_camera(first_char_pos)
	active_character.play_turn()
