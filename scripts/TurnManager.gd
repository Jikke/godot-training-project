extends Node2D

class_name TurnManager

var active_character
@onready var level = $".."
signal battle_ended

func init():
	active_character = get_child(0)

func update_next_active_character():
	var new_index : int = (active_character.get_index() + 1) % get_child_count()
	active_character = get_child(new_index)

func _on_turn_done():
	if battle_finished():
		battle_ended.emit()
	update_next_active_character()
	var active_char_pos = active_character.get_pos()
	level.move_camera(active_char_pos)
	active_character.play_turn()

func start_battle():
	var first_char_pos = active_character.get_pos()
	level.move_camera(first_char_pos)
	active_character.play_turn()

func battle_finished() -> bool:
	# Battle ends when there's mercenaries from only one team left
	var finished = true
	var compared_team = ""
	if self.get_child(0):
		compared_team = get_child(0).get_groups()[0]
	for child in self.get_children():
		# If even one mercenary isn't in compared_team group, there's still two teams battling
		if !child.is_in_group(compared_team):
			finished = false
			break
	return finished
