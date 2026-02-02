extends Area2D

var experience

var type: coin:
	set(value):
		$Sprite2D.texture = value.sprite
		experience = value.experience


func _on_body_entered(body: Node2D) -> void:
	queue_free()
