extends Control

@export var weapon1: TextureRect
@export var l_monedas: Label

var monedas: int = 0

func _ready(): 
	add_to_group("uiweapon")

func actualizarsprite(textura1: Texture):
	weapon1.texture = textura1

func sumarmonedas():
	monedas += 50
	l_monedas.text = str(monedas)
