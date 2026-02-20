extends Control

@export var mejoras: Array[Button]

var weapon_sel: int

func _ready(): 
	add_to_group("levelupscreen")
	#al clickear un boton 
	
	for b in mejoras:
		b.pressed.connect(_click.bind(b, weapon_sel))	

func aplicarmejora(weapon_sent: int):
	var stats: Array[String] = ["damage", "speed", "cooldown", "amount"]
	var random_stat: Array[String] = []
	
	for i in range(3):
		random_stat.append(stats.pick_random()) #pickeo stat
	
	for i in range(3):
		mejoras[i].text = random_stat[i] #texto en cada boton
	
	weapon_sel = weapon_sent


func _despausar():
	get_tree().paused = false 
	visible = false

func _click(boton: Button, weapon_sel: int):
	var mejora := boton.text
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
