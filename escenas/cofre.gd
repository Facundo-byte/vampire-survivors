extends Area2D

@export var sprite: AnimatedSprite2D

func _ready(): 
	sprite.play("default")
	
func _on_body_entered(body: Node2D) -> void:
	queue_free()
