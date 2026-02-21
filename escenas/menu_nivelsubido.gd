extends Control

@export var mejoras: Array[TextureButton]

@export var tex_damage: Texture2D
@export var tex_speed: Texture2D
@export var tex_cooldown: Texture2D
@export var tex_amount: Texture2D

var weapon_sel: int

func _ready(): 
	add_to_group("levelupscreen")
	#al clickear un boton 
	
	for b in mejoras:
		b.pressed.connect(_click.bind(b))	

func aplicarmejora(weapon_sent: int):
	var stats := ["damage", "speed", "cooldown", "amount"]
	var random_stat: Array[String] = []

	var stat_count := {} # cuenta cuántas veces sale cada stat
	
	var stat_textures := {
		"damage": tex_damage,
		"speed": tex_speed,
		"cooldown": tex_cooldown,
		"amount": tex_amount
	}

	while random_stat.size() < 3:
		var pick = stats.pick_random()

		if not stat_count.has(pick):
			stat_count[pick] = 0

		# permitimos como máximo 2 repeticiones
		if stat_count[pick] < 2:
			random_stat.append(pick)
			stat_count[pick] += 1

	for i in range(3):
		var stat := random_stat[i]
		mejoras[i].set_meta("mejora", stat)
		mejoras[i].texture_normal = stat_textures[stat]

	weapon_sel = weapon_sent

func _despausar():
	get_tree().paused = false 
	visible = false

func _click(boton: TextureButton):
	var mejora : String = boton.get_meta("mejora")
	
	var jugador = get_tree().get_first_node_in_group("player")
	var p = jugador.weapon_stats
	
	match mejora: 
		"damage":
			p.damage += p.damage * 0.15
			print("cambiado1")
		"speed":
			p.speed += p.speed * 0.15
			print("cambiado2")
		"amount": 
			p.amount += 1
			print("cambiado3")
		"cooldown": 
			jugador.cooldown_atq.wait_time -= p.cooldown * 0.15
			print("cambiado4")
	
	print(mejora)
	_despausar()
