extends Control

@export var weapon_type: Array[weapon]
@export var nivel1: PackedScene

@export var arma1: TextureButton 
@export var arma2: TextureButton 
@export var arma3: TextureButton 

func _ready():
	arma1.texture_normal = weapon_type[0].sprite
	arma2.texture_normal = weapon_type[1].sprite
	arma3.texture_normal = weapon_type[2].sprite

	arma1.pressed.connect(_seleccionada.bind(0))
	arma2.pressed.connect(_seleccionada.bind(1))
	arma3.pressed.connect(_seleccionada.bind(2))
	
func _seleccionada(tipoarma: int):
	var escena_padre = get_parent()
	
	escena_padre.weapon_chosen = tipoarma #le envio el tipo de arma a la escena principal
	escena_padre.chosen = true #le digo que ya se eligio un arma
