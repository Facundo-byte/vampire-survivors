# GameState.gd
extends Node

var coins: int = 54 #cant monedas totales en el juego
var game_coins: int #cantidad de monedas en la partida
var weapon_unlocked := [true, false, false] #armas bloqueadas y desbloqueadas
var weapon_selected := -1 #arma seleccionada
var game_running := false #juego corriendo o no
var minutos: int = 0
var segundos: int = 0
var level: int

func start_game(weapon_id: int): 
	weapon_selected = weapon_id
	game_running = true

func end_game():
	game_running = false
