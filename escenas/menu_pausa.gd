extends Control

@export var buttons: Array[TextureButton]

func _ready(): 
	add_to_group("pausa")
	
	for i in range(buttons.size()):
		buttons[i].pressed.connect(_click.bind(i))
	
	if visible: 
		get_tree().paused = true

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pausa"): 
		print("hola")
		visible = !visible
		get_tree().paused = !get_tree().paused

func _click(option: int): 
	if option == 0: 
		get_tree().paused = false
		visible = false
	else: 
		get_tree().quit()
