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
	$Money.visible = false
	
func show_money():
	$Money.visible = true

func show_run_button():
	$Run.visible = true

func hide_run_button():
	$Run.visible = false

func _on_run_button_up():
	hide_run_button()
	Global.goto_scene("res://scenes/game_control.tscn")
	Global.ui.show_money()
