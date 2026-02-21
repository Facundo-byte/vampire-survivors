extends Control

@export var botones: Array[TextureButton]
@export var b_monedas: Label

var monedas = GestorJuego.coins

func _ready():
	for i in range(botones.size()): 
		botones[i].pressed.connect(_click.bind(i))
	b_monedas.text = str(monedas)
		
func _click(boton_selec: int):
	if !boton_selec:
		get_tree().change_scene_to_file("res://escenas/seleccionarma.tscn")
	else:
		get_tree().quit()
	
