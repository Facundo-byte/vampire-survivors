extends Area2D

@export var speed := 400 
var direction := Vector2.RIGHT 

func _ready():
	rotation = direction.angle()

func _process(delta: float) -> void: 
	position += direction * speed * delta

func _on_despawn_timeout() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(1)
		queue_free()
