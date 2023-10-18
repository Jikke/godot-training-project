extends Control

var currently_selected_rows : Array = []
var row_preload = preload("res://scenes/row.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	# Check root of parent node (Hire- or TeamMenu) for is_shop value
	var is_shop = get_owner().is_shop
	if is_shop:
		self.populate_shop()
	if !is_shop:
		self.populate_team()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func populate_shop():
	for row in Global.shop_content:
		var texture_path = row[0]
		var name = row[1]
		var price = row[2]
		var max_health = row[3]
		var attack = row[4]
		var new_row = row_preload.instantiate()
		new_row.init(texture_path, name, price, max_health, attack)
		new_row.row_selected.connect(_on_row_selected)
		$PanelContainer/VBoxContainer/ScrollContainer/Hires.add_child(new_row)

func populate_team():
	for row in Global.current_team:
		var texture_path = row[0]
		var name = row[1]
		var price = row[2]
		var max_health = row[3]
		var attack = row[4]
		var new_row = row_preload.instantiate()
		new_row.init(texture_path, name, price, max_health, attack)
		new_row.row_selected.connect(_on_row_selected)
		new_row.hide_price()
		$PanelContainer/VBoxContainer/ScrollContainer/Hires.add_child(new_row)


func _on_row_selected(row_id, selected):
	var row_object = instance_from_id(row_id)
	if selected:
		currently_selected_rows.append(row_object)
	else:
		currently_selected_rows.erase(row_object)

