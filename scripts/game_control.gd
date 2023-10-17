extends Control


func _ready():
	pass

func _on_save_button_button_up():
	Global.save_data()
	print("Game saved!")
	Global.goto_scene("res://scenes/main_control.tscn")
	Global.wipe_game()

func _on_hire_button_button_up():
	Global.goto_scene("res://scenes/hire_control.tscn")

func _on_team_button_button_up():
	Global.goto_scene("res://scenes/team_control.tscn")



func _on_battle_button_button_up():
	Global.ui.hide_money()
	Global.goto_scene("res://scenes/levels/level1.tscn")
