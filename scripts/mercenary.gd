extends CharacterBody2D

var tile_size : int = 16
var turn : bool = false
var moving : bool = false
var move_speed : int = 1

var left : int = 0
var right : int = 0
var up : int = 0
var down : int = 0

@export var texture := load("res://icon.svg")
var merc_name : String = ""
@export var hitpoints : int = 0
@export var power : int = 0

var current_colliders : Dictionary = {}
var current_direction : String = ""

signal started_moving
signal finished_action
signal move_input_received
signal turn_done

# LISÄÄ VERSIOHALLINTAAN NYKYINEN VERSIO. LIIKKUMINEN JA VUOROJENJAKELU TUNTUU TOIMIVAN. TAPPELU EI KUNNOLLA.

func _ready():
	$TextureRect.texture = texture

func init(texture_path, merc_name, hitpoints, power):
	self.update_texture(texture_path)
	self.merc_name = name
	self.hitpoints = hitpoints
	self.power = power

func update_texture(texture_path) -> bool:
	if FileAccess.file_exists(texture_path):
		texture = load(texture_path)
		$TextureRect.texture = texture
		return true
	return false

func _input(event):
	if turn:
		if event.is_action_released("Up movement") and !moving:
			current_direction = "up"
		if event.is_action_released("Down movement") and !moving:
			current_direction = "down"
		if event.is_action_released("Left movement") and !moving:
			current_direction = "left"
		if event.is_action_released("Right movement") and !moving:
			current_direction = "right"
		if current_direction != "":
			move_input_received.emit()

func execute_action():
	# Check if there's collider in current_direction
	if current_direction in current_colliders:
		var target = current_colliders[current_direction]
		if check_validity(target):
			self.attack(target)
	else:
		# No colliders so movement is possible
		self.set(current_direction, tile_size)
		moving = true
		started_moving.emit()

func play_turn():
	turn = true
	self.switch_pointer_visibility()
	# Check colliders before moving
	self.current_colliders = self.get_collision_targets()
	await move_input_received
	execute_action()
	await finished_action
	end_turn()

func movement():
	if moving:
		while up != 0 or down != 0 or left != 0 or right != 0:
			if up != 0:
				global_position.y -= move_speed
				up -= move_speed
			if down != 0:
				global_position.y += move_speed
				down -= move_speed
			if left != 0:
				global_position.x -= move_speed
				left -= move_speed
			if right != 0:
				global_position.x += move_speed
				right -= move_speed
			await get_tree().create_timer(0.001).timeout
		moving = false

func _on_started_moving():
	await movement()
	finished_action.emit()

func get_collision_targets() -> Dictionary:
	var colliders : Dictionary = {}
	if $Up.is_colliding():
		colliders["up"] = $Up.get_collider()
	if $Down.is_colliding():
		colliders["down"] = $Down.get_collider()
	if $Left.is_colliding():
		colliders["left"] = $Left.get_collider()
	if $Right.is_colliding():
		colliders["right"] = $Right.get_collider()
	return colliders

func check_validity(target):
	if ((target.is_in_group("enemy_team") and self.is_in_group("player_team"))
	 or (target.is_in_group("player_team") and self.is_in_group("enemy_team"))):
		return true
	return false

func attack(target):
	target.defend(self.power)
	finished_action.emit()

func defend(opponent_power):
	if self.hitpoints - opponent_power <= 0:
		self.hitpoints = 0
		self.defeat()
	else:
		self.hitpoints -= opponent_power
		print(self, " got hit for ", power, " and has ", hitpoints, " left!")

func defeat():
	self.queue_free()

func end_turn():
	self.switch_pointer_visibility()
	current_colliders = {}
	current_direction = ""
	turn = false
	turn_done.emit()

func get_pos() -> Vector2:
	return global_position

func switch_pointer_visibility():
	$Tile0103.visible = not $Tile0103.visible


func _on_finished_action():
	pass # Replace with function body.
