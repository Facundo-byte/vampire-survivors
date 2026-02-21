extends Node2D

@export var player: CharacterBody2D 
@export var enemy: PackedScene 

var distance: float = 1000 
var can_spawn: bool = true

@export var enemy_types: Array[Enemy]

var minute: int: 
	set(value): 
		minute = value 
		%Minute.text = str(value)

var second: int: 
	set(value): 
		second = value 
		if second >= 60: 
			second -= 60 
			minute += 1
		%Second.text = str(second).lpad(2, '0')

func _ready():
	add_to_group("spawner")
		
func spawn(pos: Vector2, elite: bool = false): 
	if !GestorJuego.game_running: #si ya termino la partida salgo
		return
		
	if get_tree().get_node_count_in_group("enemy") >= 500: #si hay mas de 500 mobs no spawnea mas
		can_spawn = false
	else: can_spawn = true
	
	if !can_spawn: 
		return
	var enemy_instance = enemy.instantiate() 
	
	enemy_instance.position = pos
	enemy_instance.player_reference = player 
	enemy_instance.type = enemy_types[min(minute, enemy_types.size() - 1)]
	if elite: 
		enemy_instance.elite = true 
		enemy_instance.health = enemy_instance.health + 10
		
	get_parent().add_child(enemy_instance)
	

func get_random_position() -> Vector2: 
	return player.position + distance * Vector2.RIGHT.rotated(randf_range(0,2 * PI))

func amount(number: int = 1): 
	for i in range(number): 
		spawn(get_random_position())

func _on_timer_timeout() -> void:
	if !GestorJuego.game_running: #si ya termino la partida salgo
		return
	second += 1 
	
func _on_pattern_timeout() -> void:
	if !GestorJuego.game_running: #si ya termino la partida salgo
		return
	amount(second % 100)

func _on_elite_timeout() -> void:
	if !GestorJuego.game_running: #si ya termino la partida salgo
		return
	spawn(get_random_position(), true)
