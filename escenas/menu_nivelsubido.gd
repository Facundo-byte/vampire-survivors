extends Control

@export var mejora1: Button
@export var mejora2: Button
@export var mejora3: Button

func _ready(): 
	add_to_group("levelupscreen")
	
	#al clickear un boton 
	mejora1.pressed.connect(_click)
	mejora2.pressed.connect(_click)
	mejora3.pressed.connect(_click)
	
func _despausar():
	get_tree().paused = false 
	visible = false

func _click():
	_despausar()
