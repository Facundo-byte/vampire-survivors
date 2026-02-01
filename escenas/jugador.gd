extends CharacterBody2D

@export var animacion : AnimatedSprite2D
@export var bar: ProgressBar
@export var attack: PackedScene

var ant_move_dir
var move_dir
var distance: float = 300
var speed: float = 200.0 #defino la velocidad a la q se mueve el pj
var health: float = 100: 
	set(value):
		health = value
		%Health.value = value
var knife

func _process(delta):
	move_dir = Input.get_vector("izquierda", "derecha", "arriba", "abajo")
	velocity = move_dir * speed 
	move_dir.normalized()
	move_and_collide(velocity * delta)
	
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
	knife = attack.instantiate()
	knife.global_position = global_position + move_dir * 16
	
	if move_dir != Vector2.ZERO: 
		ant_move_dir = move_dir
		knife.direction = move_dir 
	elif ant_move_dir: 
		knife.direction = ant_move_dir
	else: 
		knife.direction = move_dir
	
	get_tree().current_scene.add_child(knife)
