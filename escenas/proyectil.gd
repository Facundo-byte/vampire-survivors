extends Area2D

@export var number_ref : PackedScene
@export var weapontype: Array[weapon]
@export var speed: float = 400
var direction := Vector2.RIGHT 

func _ready():
	rotation = direction.angle()

func _process(delta: float) -> void: 
	position += direction * speed * delta

func _on_screen_exited():
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	
	var dmg = number_ref.instantiate()
	dmg.position = position
	dmg.text = str(1)
	get_parent().add_child(dmg) #numeros de danio
	
	body.take_damage(1) #enemigo recibiendo danio y cuchillo desapareciendo
	queue_free()
