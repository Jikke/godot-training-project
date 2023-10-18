extends Node

var save_path = "user://savefile.save"
var current_scene = null
var money: int = 0
const character_sprite_paths : Array = [
	"res://assets/Tiles/tile_0084.png", 
	"res://assets/Tiles/tile_0085.png", 
	"res://assets/Tiles/tile_0086.png", 
	"res://assets/Tiles/tile_0087.png", 
	"res://assets/Tiles/tile_0088.png",
	"res://assets/Tiles/tile_0097.png",
	"res://assets/Tiles/tile_0098.png", 
	"res://assets/Tiles/tile_0099.png", 
	"res://assets/Tiles/tile_0100.png"
	]
var shop_content : Array = []
var name_generator = preload("res://scripts/name-generator.gd").new()
var current_team : Array = []
@onready var ui = get_node("/root/Ui")

func _ready():
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func wipe_game():
	update_money(0)
	shop_content = []
	current_team = []
	pass

func update_money(amount):
	self.money = amount
	ui.update_money_text(amount)

func goto_scene(path):
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:

	call_deferred("_deferred_goto_scene", path)


func _deferred_goto_scene(path):
	# It is now safe to remove the current scene
	current_scene.free()

	# Load the new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = s.instantiate()

	# Add it to the active scene, as child of root.
	get_tree().root.add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene_to_file() API.
	get_tree().current_scene = current_scene

func generate_shop_content(size):
	shop_content.resize(size)
	for i in range(size):
		var char_texture_path = character_sprite_paths.pick_random()
		var name : String = name_generator.generate(5, 10)
		randomize()
		var price : int = int(randf_range(10, 50))
		var hitpoints : int = int(randf_range(10, 30))
		var power : int = int(randf_range(2, 6))
		shop_content[i] = [char_texture_path, name, price, hitpoints, power]
		

func hire(shop_index):
	# pop_at removes and returns value at index
	var new_hire = shop_content.pop_at(shop_index)
	current_team.append(new_hire)

func fire(team_index):
	current_team.pop_at(team_index)

func save_data():
	var data : Array = [money, shop_content, current_team]
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(data)

func load_data() -> bool:
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		var data = file.get_var()
		money = data[0]
		shop_content = data[1]
		current_team = data[2]
		return true
	else:
		return false

func delete_save_file():
	var dir = DirAccess.open("user://")
	if dir:
		dir.remove(save_path)
		print("Save file deleted!")
		return true
	else:
		print("file not found")
		return false
	
	
