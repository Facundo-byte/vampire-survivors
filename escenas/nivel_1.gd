extends Node2D

@export var chunks: Array[TileMapLayer]
@export var player: CharacterBody2D

var CHUNK_HEIGHT : int = 2112
var h_mult: int = 1

var repeats: int = 2

func _ready():
	chunks[0].position.y = -1 * CHUNK_HEIGHT
	chunks[1].position.y = 0 * CHUNK_HEIGHT
	chunks[2].position.y = 1 * CHUNK_HEIGHT

func _process(_float) ->void:
	if player.position.y > -1 && player.position.y < 1: #si llegas al spawn se resetea el multiplicador
		h_mult = 1
	
	if player.position.y >= CHUNK_HEIGHT * h_mult: ##si estas bajando desaparece el de arriba y lo hace aparecer abajo
		if h_mult % 2 == 0: 
			chunks[1].position.y = repeats * CHUNK_HEIGHT
		else: 
			chunks[0].position.y = repeats * CHUNK_HEIGHT
		repeats += 1
		h_mult += 1
	
	if player.position.y <= -CHUNK_HEIGHT * h_mult: 
		if h_mult % 2 == 0: 
			chunks[1].position.y = repeats * -CHUNK_HEIGHT
		else: 
			chunks[2].position.y = repeats * -CHUNK_HEIGHT
		repeats += 1
		h_mult += 1
	
