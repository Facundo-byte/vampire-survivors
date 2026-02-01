extends CharacterBody2D

@export var player_reference: CharacterBody2D
@export var speed: float = 75

var health: float
var direction: Vector2
var damage: float 
var elite: bool = false: 
	set(value): 
		if value: 
			$Sprite2D.material = load("res://shaders/rainbow_outline_material.tres")
			scale = Vector2(2,2)

var type: Enemy: 
	set(value): 
		$Sprite2D.texture = value.texture 
		damage = value.damage
		health = value.health
		
func _physics_process(delta):
	velocity = (player_reference.position - position).normalized() * speed 
	if velocity.x < 0: 
		$Sprite2D.flip_h = true 
	else: 
		$Sprite2D.flip_h = false
	move_and_collide(velocity * delta)

func take_damage(amount): ##recibir danio
	health -= amount
	if !health: 
		queue_free()
	print(health)
