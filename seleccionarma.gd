extends Control

@export var weapon_type: Array[weapon]
@export var nivel1: PackedScene

@export var arma1: TextureButton 
@export var arma2: TextureButton 
@export var arma3: TextureButton 

@export var precio1: Label 
@export var precio2: Label

@export var container1: HBoxContainer
@export var container2: HBoxContainer

@export var b_monedas: Label

var monedas: int = GestorJuego.coins

func _ready():
	arma1.texture_normal = weapon_type[0].sprite
	arma2.texture_normal = weapon_type[1].sprite
	arma3.texture_normal = weapon_type[2].sprite

	arma1.pressed.connect(_seleccionada.bind(0)) 
	arma2.pressed.connect(_seleccionada.bind(1))
	arma3.pressed.connect(_seleccionada.bind(2))
	
	precio1.text = str(weapon_type[0].price)
	precio2.text = str(weapon_type[2].price)
	
	if precio1.text == "0": 
		container1.visible = false 
	if precio2.text == "0": 
		container1.visible = false 
	
	b_monedas.text = str(monedas)
	
func _seleccionada(tipoarma: int):
	if weapon_type[tipoarma].price > GestorJuego.coins: 
		return
	var escena_padre = get_parent()
	
	GestorJuego.coins -= weapon_type[tipoarma].price
	weapon_type[tipoarma].price = 0
	GestorJuego.start_game(tipoarma) #le asigno el tipo de arma
	escena_padre.nivel_actual += 1 #hago que el numero de escena cambie
	escena_padre.crear_nivel(escena_padre.nivel_actual) #cargo la nueva escena
