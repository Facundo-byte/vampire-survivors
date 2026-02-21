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
		var escena_p = get_parent()
		escena_p.nivel_actual += 1
		escena_p.crear_nivel(escena_p.nivel_actual)
	else:
		get_tree().quit()
	
