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
	fire_mercs(selected_mercs)

func fire_mercs(selected_rows) -> void:
	for row in selected_rows:
		var merc_as_row = [row.row_texture.resource_path, 
			row.row_name, 
			row.row_price,
			row.row_max_health, 
			row.row_attack]
		var team_index = Global.current_team.find(merc_as_row)
		Global.fire(team_index)
		row.queue_free()
	%"Team List".currently_selected_rows = []
