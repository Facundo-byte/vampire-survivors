extends Area2D

@export var sprite: AnimatedSprite2D

func _ready(): 
	sprite.play("default")
	
func _on_body_entered(body: Node2D) -> void:
	var jugador = get_tree().get_first_node_in_group("player")
	var ui = get_tree().get_first_node_in_group("uiweapon")
	
	ui.sumarmonedas()
	jugador.add_exp(jugador.expbar.max_value)
	queue_free()
