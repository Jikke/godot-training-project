extends Control

func _ready():
	if !Global.load_data():
		%"Continue Button".hide()

func _on_new_game_button_button_up():
	delete_and_wipe()
	Global.generate_shop_content(30)
	Global.update_money(1000)
	Global.ui.show_money()
	Global.goto_scene("res://scenes/game_control.tscn")
	

func _on_continue_button_button_up():
	Global.load_data()
	Global.update_money(Global.money)
	Global.ui.show_money()
	Global.goto_scene("res://scenes/game_control.tscn")

func _on_exit_button_button_up():
	Global.wipe_game()
	get_tree().quit()

func _on_delete_save_button_button_up():
	delete_and_wipe()

func delete_and_wipe():
	if Global.delete_save_file():
		Global.wipe_game()
		%"Continue Button".hide()
