extends CharacterBody2D

@export var player_reference: CharacterBody2D
@export var speed: float = 75
@export var coin_drop: PackedScene
@export var coin_droptype: Array[coin]
@export var chest_drop: PackedScene

var knockback: Vector2
var title: String
var health: float
var direction: Vector2
var damage: float 

var elite: bool = false: 
	set(value): 
		elite = value
		if value: 
			$Sprite2D.material = load("res://shaders/rainbow_outline_material.tres")
			scale = Vector2(2,2)

var type: Enemy: 
	set(value): 
		$Sprite2D.texture = value.texture 
		damage = value.damage
		health = value.health
		title = str(value.title)
		
var separation

func _ready():
	add_to_group("enemy")	
	player_reference = get_tree().get_first_node_in_group("player")
	
func _physics_process(delta):
	if !GestorJuego.game_running: #si ya termino la partida salgo
		return
	separation = (player_reference.position - position).length()
	if separation >= 700 and not elite: 
		queue_free()
	
	if separation < player_reference.nearest_enemy_distance: 
		player_reference.nearest_enemy = self
		
	velocity = (player_reference.position - position).normalized() * speed 
	knockback = knockback.move_toward(Vector2.ZERO, 1)
	velocity += knockback
	
	if velocity.x < 0: 
		$Sprite2D.flip_h = true 
	else: 
		$Sprite2D.flip_h = false
		
	var collider = move_and_collide(velocity * delta)
	if collider: 
		collider.get_collider().knockback = (collider.get_collider().global_position - global_position). normalized() * 50

func take_damage(amount): ##recibir danio
	var item_instantiate
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "modulate", Color(1.0, 0.0, 0.0, 1.0), 0.2)
	tween.chain().tween_property($Sprite2D, "modulate", Color(1,1,1), 0.2)
	
	health -= amount
	if health < 1: 
		if !elite: #si no es de elite, me fijo si es calavera u ojo, si lo es suelta moneda verde, sino azul
			item_instantiate = coin_drop.instantiate()
			
			if title == "skull" or title == "eye": 
				item_instantiate.type = coin_droptype[0]
			else: 
				item_instantiate.type = coin_droptype[1]
			call_deferred("itemspawn",item_instantiate)
		else: 
			item_instantiate = chest_drop.instantiate()
			call_deferred("itemspawn", item_instantiate)	
			
		call_deferred("queue_free")
	print(health)

func itemspawn(item_instantiate: Area2D):
	item_instantiate.position = global_position
	get_parent().add_child(item_instantiate)
