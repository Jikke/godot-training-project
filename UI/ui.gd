extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	%"Money-amount".text = str(Global.money)
#	match Global.ui_type:
#		"menu": show_money()
#		"battle": hide_money()

func hide_money():
	$"Control/HBoxContainer/Money-title".hide()
	%"Money-amount".hide()
	
func show_money():
	$Control.show()
