extends Node2D

@export var niveles: Array[PackedScene]
var nivel_actual: int = 1
var _nivel_instanciado: Node 

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
