extends Control

# Modifies element_list accordingly
var is_shop = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_return_button_button_up():
	Global.goto_scene("res://scenes/game_control.tscn")


func _on_fire_button_button_up() -> void:
	var selected_mercs = %"Team List".currently_selected_rows
