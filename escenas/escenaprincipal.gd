extends Node2D

@export var niveles: Array[PackedScene]
var _nivel_actual: int = 1
var _nivel_instanciado: Node 

var weapon_chosen: int #arma elegida
var chosen: bool #si eligio o no un arma

#sonidos muerte
@export var sonido_mjugador: AudioStreamPlayer2D

func _ready() -> void:
	_crear_nivel(_nivel_actual)
	#si el jugador muere cargo derrota
	#ControladorGlobal.jugador_muerto.connect(_cargar_fin.bind(1, jugador, enemigo))
	#si el enemigo muere cargo victoria
	#ControladorGlobal.enemigo_muerto.connect(_cargar_fin.bind(2, jugador, enemigo))

func _process(float) -> void:
	if chosen: 
		_crear_nivel(2)
		chosen = false
	
func _crear_nivel(numero_nivel: int):
	_nivel_instanciado = niveles[numero_nivel - 1].instantiate()
	if chosen: 
		_nivel_instanciado.weapon_chosen = weapon_chosen
	add_child(_nivel_instanciado)
	
func _eliminar_nivel():
	_nivel_instanciado.queue_free()

func _reiniciar_nivel():
	_eliminar_nivel()
	_crear_nivel.call_deferred(_nivel_actual)

func _ir_al_menu():
	get_tree().change_scene_to_file("res://escenas/menus/menus.tscn")
