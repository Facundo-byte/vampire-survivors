extends Node2D

@export var niveles: Array[PackedScene]
var nivel_actual: int = 1
var _nivel_instanciado: Node 

var chosen: bool #si eligio o no un arma

#sonidos muerte
@export var sonido_mjugador: AudioStreamPlayer2D

func _ready() -> void:
	crear_nivel(nivel_actual)
	
func crear_nivel(numero_nivel: int):
	if _nivel_instanciado:
		_eliminar_nivel()
	_nivel_instanciado = niveles[numero_nivel - 1].instantiate()
	add_child(_nivel_instanciado)
	
func _eliminar_nivel():
	_nivel_instanciado.queue_free()

func _reiniciar_nivel():
	_eliminar_nivel()
	crear_nivel.call_deferred(nivel_actual)

func _ir_al_menu():
	get_tree().change_scene_to_file("res://escenas/menu_principal.tscn")
