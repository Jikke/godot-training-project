extends Control

# Modifies element_list accordingly
var is_shop = true

func _ready():
	pass

func _on_return_button_button_up() -> void:
	Global.goto_scene("res://scenes/game_control.tscn")

func _on_hire_button_button_up() -> void:
	var selected_rows = %"Hiring List".currently_selected_rows
	var total_price = self.check_price(selected_rows)
	if total_price != -1:
		var leftover_money = Global.money - total_price
		Global.update_money(leftover_money)
	else:
		print("Not enough money!")
		return
	hire_mercs(selected_rows)
	
func check_price(selected_rows) -> int:
	var total_price : int = 0
	for row in selected_rows:
		total_price += row.row_price
	if Global.money >= total_price:
		return total_price
	return -1

func hire_mercs(selected_rows) -> void:
	for row in selected_rows:
		var merc_as_row = [row.row_texture.resource_path, 
			row.row_name, 
			row.row_price, 
			row.row_hitpoints, 
			row.row_attack]
		var shop_index = Global.shop_content.find(merc_as_row)
		Global.hire(shop_index)
		row.queue_free()
	%"Hiring List".currently_selected_rows = []
