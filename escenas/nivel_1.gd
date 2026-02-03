extends Node2D

@export var chunks: Array[TileMapLayer]
@export var player: CharacterBody2D

var CHUNK_HEIGHT : int = 2112
var h_mult: int = 1
var current_chunk := 0

var repeats: int = 2

func _ready():
	chunks[0].position.y = -1 * CHUNK_HEIGHT
	chunks[1].position.y = 0 * CHUNK_HEIGHT
	chunks[2].position.y = 1 * CHUNK_HEIGHT

func _physics_process(delta):
	var new_chunk = int(floor(player.position.y / CHUNK_HEIGHT))

	if new_chunk > current_chunk:
		# bajando → mover el de arriba hacia abajo
		var top_chunk = get_top_chunk()
		top_chunk.position.y = (new_chunk + 1) * CHUNK_HEIGHT

	elif new_chunk < current_chunk:
		# subiendo → mover el de abajo hacia arriba
		var bottom_chunk = get_bottom_chunk()
		bottom_chunk.position.y = (new_chunk - 1) * CHUNK_HEIGHT
	current_chunk = new_chunk

func get_top_chunk() -> Node2D:
	var top = chunks[0]
	for c in chunks:
		if c.position.y < top.position.y:
			top = c
	return top

func get_bottom_chunk() -> Node2D:
	var top = chunks[0]
	for c in chunks:
		if c.position.y > top.position.y:
			top = c
	return top
