extends Control

var direction : String = ""
var sprite 
var hitpoints : int = 0
var max_health : int = 0
const adj_enemy_merc_stylebox : StyleBoxFlat = preload("res://styleboxes/adjacent_enemy_merc_style_box_flat.tres")

func _ready():
	pass

func init(direction, sprite, hitpoints, max_health, is_enemy):
	self.direction = direction
	%Direction.text = direction
	self.sprite = sprite
	%Sprite2D.texture = sprite
	self.update_hitpoints(hitpoints)
	self.max_health = max_health
	%"Max Health".text = str(max_health)
	if is_enemy:
		$PanelContainer.add_theme_stylebox_override("panel", adj_enemy_merc_stylebox)
		modulate_enemy_sprite()

func modulate_enemy_sprite():
	%Sprite2D.modulate = Color(1, 0.4, 0.5)

func update_hitpoints(hitpoints):
	self.hitpoints = hitpoints
	%Hitpoints.text = str(hitpoints)

func show_adj_merc():
	$".".visible = true

func hide_adj_merc():
	$".".visible = false
