extends Control

@export var weapon1: TextureRect

func _ready(): 
	add_to_group("uiweapon")

func actualizarsprite(textura1: Texture):
	weapon1.texture = textura1
