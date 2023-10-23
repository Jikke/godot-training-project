extends CanvasLayer

var adj_merc_preload = preload("res://scenes/adjacent_mercenary.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	hide_money()
	hide_run_button()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_money_text(amount):
	%"Money-amount".text = str(amount)
	
func show_money():
	%Money.visible = true

func hide_money():
	%Money.visible = false

func show_run_button():
	%Run.visible = true

func hide_run_button():
	%Run.visible = false

func _on_run_button_up():
	hide_run_button()
	remove_colliders()
	Global.goto_scene("res://scenes/game_control.tscn")
	Global.ui.show_money()

func _on_colliders_found(colliders, my_group):
	remove_colliders()
	for collider in colliders:
		var direction = collider
		direction = direction.capitalize()
		var texture = colliders[collider].sprite
		var hitpoints = colliders[collider].hitpoints
		var max_health = colliders[collider].max_health
		var collider_group = colliders[collider].get_groups()[0]
		var is_enemy = false
		if my_group != collider_group:
			is_enemy = true
		var new_adj_merc = adj_merc_preload.instantiate()
		new_adj_merc.init(direction, texture, hitpoints, max_health, is_enemy)
		$HBoxContainer/VBoxContainer/VBoxContainer.add_child(new_adj_merc)

func remove_colliders():
	for child in $HBoxContainer/VBoxContainer/VBoxContainer.get_children():
		$HBoxContainer/VBoxContainer/VBoxContainer.remove_child(child)
