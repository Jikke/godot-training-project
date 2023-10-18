extends CharacterBody2D

var tile_size : int = 16
var turn : bool = false
var moving : bool = false
var move_speed : int = 2

var left : int = 0
var right : int = 0
var up : int = 0
var down : int = 0

@export var sprite := load("res://icon.svg")
var merc_name : String = ""
@export var max_health : int = 0
var hitpoints : int = 0
@export var power : int = 0

var current_colliders : Dictionary = {}
var current_input : String = ""

signal colliders_found(current_colliders, my_group)
signal started_moving
signal finished_moving
signal move_input_received
signal turn_done

func _ready():
	$Sprite2D.texture = sprite

func init(texture_path, merc_name, max_health, power):
	self.update_texture(texture_path)
	self.merc_name = name
	self.max_health = max_health
	self.hitpoints = max_health
	self.power = power

func update_texture(texture_path) -> bool:
	if FileAccess.file_exists(texture_path):
		sprite = load(texture_path)
		$Sprite2D.texture = sprite
		return true
	return false

func modulate_enemy_sprite():
	$Sprite2D.modulate = Color(1, 0.4, 0.5)

func _input(event):
	if turn:
		if event.is_action_released("Spacebar") and !moving:
			current_input = "pass"
		if event.is_action_released("Up movement") and !moving:
			current_input = "up"
		if event.is_action_released("Down movement") and !moving:
			current_input = "down"
		if event.is_action_released("Left movement") and !moving:
			current_input = "left"
		if event.is_action_released("Right movement") and !moving:
			current_input = "right"
		if current_input != "":
			move_input_received.emit()

func execute_action() -> bool:
	# Check if there's collider in current_input
	if current_input in current_colliders:
		var target = current_colliders[current_input]
		if check_validity(target):
			self.attack(target)
			return true
	else:
		# No colliders so movement is possible
		self.set(current_input, tile_size)
		moving = true
		started_moving.emit()
		return true
	# No action was finished, return false
	return false

func play_turn():
	turn = true
	self.switch_pointer_visibility()
	# Check colliders before moving
	self.current_colliders = self.get_collision_targets()
	colliders_found.emit(current_colliders, self.get_groups()[0])
	var action_finished = false
	while !action_finished:
		await move_input_received
		if current_input != "pass":
			action_finished = execute_action()
		else: 
			action_finished = true
	if moving:
		await finished_moving
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
			await get_tree().create_timer(0.01).timeout
		moving = false

func _on_started_moving():
	await movement()
	finished_moving.emit()

func get_collision_targets() -> Dictionary:
	var colliders : Dictionary = {}
	if $Up.is_colliding() and $Up.get_collider() != null:
		colliders["up"] = $Up.get_collider()
	if $Right.is_colliding() and $Right.get_collider() != null:
		colliders["right"] = $Right.get_collider()
	if $Down.is_colliding() and $Down.get_collider() != null:
		colliders["down"] = $Down.get_collider()
	if $Left.is_colliding() and $Left.get_collider() != null:
		colliders["left"] = $Left.get_collider()
	return colliders

func check_validity(target):
	if target != null and ((target.is_in_group("enemy_team") and self.is_in_group("player_team"))
	 or (target.is_in_group("player_team") and self.is_in_group("enemy_team"))):
		return true
	return false

func attack(target):
	target.defend(self.power)

func defend(opponent_power):
	if self.hitpoints - opponent_power <= 0:
		print(self, " had ", hitpoints, " left and got hit for ", opponent_power, " was defeated.")
		self.hitpoints = 0
		self.defeat()
	else:
		self.hitpoints -= opponent_power
		print(self, " got hit for ", opponent_power, " and has ", hitpoints, " left!")

func defeat():
	self.queue_free()
	await get_tree().create_timer(0.01).timeout

func end_turn():
	self.switch_pointer_visibility()
	current_colliders = {}
	current_input = ""
	turn = false
	# Without this line, the battling doesn't work as expected
	await get_tree().create_timer(0.01).timeout
	turn_done.emit()

func get_pos() -> Vector2:
	return global_position

func switch_pointer_visibility():
	$Tile0103.visible = not $Tile0103.visible
