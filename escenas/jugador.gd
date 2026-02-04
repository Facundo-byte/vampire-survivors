extends CharacterBody2D

@export var animacion : AnimatedSprite2D
@export var bar: ProgressBar
@export var attack: PackedScene
@export var expbar: ProgressBar #barra de experiencia
@export var cooldown_atq: Timer #tiempo de espera para atacar

var weapon_sel: int	
@export var weapon_types: Array[weapon] #array con los tipos
var weapon_stats: weapon #datos de ESTA ARMA

var ant_move_dir#movimiento
var move_dir

var speed: float = 200.0 #defino la velocidad a la q se mueve el pj
var health: float = 100: #defino su salud
	set(value):
		health = value
		%Health.value = value
		
var projectile
var nearest_enemy: CharacterBody2D #enemigo mas cercano (para el autoaim)
var nearest_enemy_distance: float = INF 

func _ready() -> void:
	add_to_group("player")

func set_weapon(id: int): #le digo que arma va a usar y reseteo el cooldown en base a ella
	weapon_sel = id
	weapon_stats = weapon_types[id]
	cooldown_atq.wait_time = weapon_stats.cooldown

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

func _on_self_damage_body_entered(body):
	take_damage(body.damage)

func _on_timer_timeout() -> void:
	%Collision.set_deferred("disabled", true)
	%Collision.set_deferred("disabled", false)

func _on_attack_timer_timeout() -> void:
	projectile = attack.instantiate()
	projectile.dmg = weapon_stats.damage
	projectile.speed = weapon_stats.speed
	projectile.global_position = global_position + move_dir * 16
	projectile.sprite.texture = weapon_stats.sprite
	
	print(projectile.dmg)
	print(projectile.speed)
	if weapon_sel == 0 or weapon_sel == 2: #si es la bola se dirige al enemigo mas cercano
		if nearest_enemy_distance != INF: 
			projectile.direction = (nearest_enemy.global_position - projectile.global_position).normalized()
			get_tree().current_scene.add_child(projectile)
	elif weapon_sel == 1: #si es el cuchillo va hacia donde se mueva el jugador
		if move_dir != Vector2.ZERO: 
			projectile.direction = move_dir 
		elif ant_move_dir: 
			projectile.direction = ant_move_dir
		else: 
			projectile.direction = Vector2.RIGHT
		get_tree().current_scene.add_child(projectile)

func add_exp(experience: float): 
	expbar.value += experience
	if expbar.value == expbar.max_value:
		var levelupmenu = get_tree().get_first_node_in_group("levelupscreen")
		levelupmenu.visible = true
		get_tree().paused = true
		expbar.max_value = expbar.max_value * 2
		expbar.value = 0
	
