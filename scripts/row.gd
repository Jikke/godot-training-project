class_name Row
extends Control

var row_texture = null
@export var row_name: String = ""
@export var row_price: int = 0
@export var row_hitpoints: int = 0
@export var row_attack: int = 0

var selected : bool = false

signal row_selected(row_id, selected)

const row_selected_stylebox : StyleBoxFlat = preload("res://styleboxes/row_selected_style_box_flat.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	$HBoxContainer/TextureRect.texture = row_texture
	$HBoxContainer/Name.text = row_name
	$HBoxContainer/Price.text = str(row_price)
	$HBoxContainer/Hitpoints.text = str(row_hitpoints)
	$HBoxContainer/Attack.text = str(row_attack)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func init(texture_path, name, hitpoints, attack, price = 0):
	update_texture(texture_path)
	self.row_name = name
	self.row_price = price
	self.row_hitpoints = hitpoints
	self.row_attack = attack

func update_texture(texture_path) -> bool:
	if FileAccess.file_exists(texture_path):
		row_texture = load(texture_path)
		$HBoxContainer/TextureRect.texture = row_texture
		return true
	return false

func hide_price():
	$HBoxContainer/Price.hide()

# (Un)select and (de)highlight a row depending on current selected status.
func _on_h_box_container_gui_input(_event):
	if Input.is_action_just_pressed("Left click"):
		var row_id = get_instance_id()
		if !selected:
			selected = true
			row_selected.emit(row_id, selected)
			set_selected_row_color(selected)
		else:
			selected = false
			row_selected.emit(row_id, selected)
			set_selected_row_color(selected)

func set_selected_row_color(is_selected : bool):
	for child in $HBoxContainer.get_children():
		if is_selected:
			child.add_theme_stylebox_override("normal", row_selected_stylebox)
		else:
			child.remove_theme_stylebox_override("normal")
