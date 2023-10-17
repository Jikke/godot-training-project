extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_money_text(amount):
	%"Money-amount".text = str(amount)

func hide_money():
	$"Control/HBoxContainer/Money-title".hide()
	%"Money-amount".hide()
	
func show_money():
	$Control.show()
