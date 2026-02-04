extends Area2D

@export var number_ref : PackedScene

var dmg: float
var speed: float
var direction := Vector2.RIGHT 
@export var sprite := Sprite2D

func _ready():
	rotation = direction.angle()

func _process(delta: float) -> void: 
	position += direction * speed * delta

func _on_screen_exited():
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	
	var dmg_number = number_ref.instantiate() #numero de danio
	dmg_number.position = position
	dmg_number.text = str(dmg)
	get_parent().add_child(dmg_number) #numeros de danio
	
	body.take_damage(dmg) #enemigo recibiendo danio y cuchillo desapareciendo
	queue_free()
