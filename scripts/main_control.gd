extends Control

func _ready():
	if !Global.load_data():
		%"Continue Button".hide()

func _on_new_game_button_button_up():
	delete_and_wipe()
	Global.goto_scene("res://scenes/game_control.tscn")
	Global.generate_shop_content(30)
	Global.money = 1000

func _on_continue_button_button_up():
	Global.load_data()
	Global.goto_scene("res://scenes/game_control.tscn")

func _on_exit_button_button_up():
	get_tree().quit()


func _on_delete_save_button_button_up():
	delete_and_wipe()

func delete_and_wipe():
	if Global.delete_save_file():
		Global.wipe_game()
		%"Continue Button".hide()
