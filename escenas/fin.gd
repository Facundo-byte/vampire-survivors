extends Control

@export var botones: Array[TextureButton]
@export var tiempo: Array[Label] 
@export var monedas: Label 
@export var lvl: Label 

func _ready():
	monedas.text = "Monedas: " + str(GestorJuego.game_coins)
	tiempo[0].text = str(GestorJuego.minutos).lpad(2, '0')
	tiempo[1].text = str(GestorJuego.segundos).lpad(2,'0')
	lvl.text = "LVL " + str(GestorJuego.level)
	for i in range(botones.size()):
		botones[i].pressed.connect(_click.bind(i))
		
func _click(tipo: int): 
	var gestor = get_parent()
	print(tipo)
	if tipo == 0:
		gestor.nivel_actual = 2
		gestor.crear_nivel(gestor.nivel_actual)
		print("uno")
	else: 
		gestor.nivel_actual = 1 
		gestor.crear_nivel(gestor.nivel_actual)
		print("dos")
		
