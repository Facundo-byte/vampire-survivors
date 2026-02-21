extends CharacterBody2D

@export var animacion : AnimatedSprite2D
@export var bar: ProgressBar
@export var attack: PackedScene
@export var expbar: TextureProgressBar #barra de experiencia
@export var cooldown_atq: Timer #tiempo de espera para atacar
@export var t_nivel: Label
@export var nivel: int = 1

var weapon_sel: int	
@export var weapon_types: Array[weapon] #array con los tipos
var weapon_stats: weapon #datos de ESTA ARMA
var total_spread := deg_to_rad(30) # 20 grados de abanico total (para cuando hay muchos proyectiles)

var ant_move_dir#movimiento
var move_dir

var speed: float = 200.0 #defino la velocidad a la q se mueve el pj
var health: float = 100: #defino su salud
	set(value):
		health = value
		%Health.value = value
		
var projectiles: Array[Area2D]
var nearest_enemy: CharacterBody2D #enemigo mas cercano (para el autoaim)
var nearest_enemy_distance: float = INF 

func _ready() -> void:
	t_nivel.text = "LVL " + str(nivel)
	add_to_group("player")

func set_weapon(id: int): #le digo que arma va a usar y reseteo el cooldown en base a ella
	weapon_sel = id
	weapon_stats = weapon_types[id]
	cooldown_atq.wait_time = weapon_stats.cooldown
	var ui_weapon = get_tree().get_first_node_in_group("uiweapon")
	ui_weapon.actualizarsprite(weapon_stats.sprite)

func _process(delta):
	if nearest_enemy: 
		nearest_enemy_distance = nearest_enemy.separation 
	else:
		nearest_enemy_distance = INF
	
	move_dir = Input.get_vector("izquierda", "derecha", "arriba", "abajo")
	velocity = move_dir * speed 
	move_dir.normalized()
	move_and_collide(velocity * delta)
	
	if move_dir != Vector2.ZERO:
		ant_move_dir = move_dir
	
	if velocity != Vector2.ZERO: 
		if velocity.x < 0: 
			animacion.flip_h = true 
		else: 
			animacion.flip_h = false
		animacion.play("idle_down")
	else: 
		animacion.stop()

func take_damage(amount): 
	health -= amount 
	print(amount)
	if !health:
		var ui = get_tree().get_first_node_in_group("uiweapon")
		var spawner = get_tree().get_first_node_in_group("spawner")
		
		GestorJuego.minutos = spawner.minute
		GestorJuego.segundos = spawner.second
		
		GestorJuego.coins += ui.monedas
		GestorJuego.game_coins = ui.monedas
		
		GestorJuego.level = nivel 
		
		GestorJuego.end_game()

func _on_self_damage_body_entered(body):
	take_damage(body.damage)

func _on_timer_timeout() -> void:
	%Collision.set_deferred("disabled", true)
	%Collision.set_deferred("disabled", false)

func _on_attack_timer_timeout() -> void:
	projectiles.clear()
		
	for i in weapon_stats.amount:
		var p = attack.instantiate()
		p.dmg = weapon_stats.damage
		p.speed = weapon_stats.speed
		p.scale.x = weapon_stats.scale
		p.scale.y = weapon_stats.scale
		p.global_position = global_position + Vector2(i * 5,i * 5) + move_dir * 16
		p.sprite.texture = weapon_stats.sprite
		projectiles.append(p)
	
	if weapon_sel == 0: #si es la bola se dirige al enemigo mas cercano
		var enemies = get_enemies_sorted_by_distance()
	
		if enemies.size() == 0:
			return
		
		for i in range(projectiles.size()):
			var enemy = enemies[i % enemies.size()]
			var p = projectiles[i]
			p.direction = (enemy.global_position - p.global_position).normalized()
			get_parent().add_child(p)
				
	elif weapon_sel == 1: #si es el cuchillo va hacia donde se mueva el jugador
		for projectile in projectiles:
			if move_dir != Vector2.ZERO: 
				projectile.direction = move_dir 
			elif ant_move_dir: 
				projectile.direction = ant_move_dir
			else: 
				projectile.direction = Vector2.RIGHT
			get_parent().add_child(projectile)
			
	else:
		if nearest_enemy_distance != INF:
			var base_dir = (nearest_enemy.global_position - global_position).normalized()
			
			var count := projectiles.size()

			for i in range(count):
				var t := 0.0
				if count > 1:
					t = float(i) / float(count - 1) - 0.5
				var angle = t * total_spread
				
				var p = projectiles[i]
				p.direction = base_dir.rotated(angle)
				get_parent().add_child(p)

func get_enemies_sorted_by_distance() -> Array: #obtengo todos los enemigos y los ordeno por la distancia
	var enemies = get_tree().get_nodes_in_group("enemy")
	enemies.sort_custom(func(a, b):
		return global_position.distance_to(a.global_position) < global_position.distance_to(b.global_position)
	)
	return enemies

func add_exp(experience: float): 
	expbar.value += experience
	if expbar.value >= expbar.max_value:
		nivel += 1
		t_nivel.text = "LVL " + str(nivel)
		var levelupmenu = get_tree().get_first_node_in_group("levelupscreen")
		levelupmenu.visible = true
		levelupmenu.aplicarmejora(weapon_sel)
		get_tree().paused = true
		expbar.max_value = expbar.max_value * 2
		expbar.value = 0
	
