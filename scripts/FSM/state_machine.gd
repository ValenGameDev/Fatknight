class_name StateMachine extends Node

@export var initial_state: State
var player: CharacterBody2D

var active_state: State:
	set (new_value):
		active_state = new_value
		print(new_value)

func _ready() -> void:
	# 1. Esperamos a que el personaje raíz esté listo
	await owner.ready
	var player_ref = owner as CharacterBody2D

	# 2. Inyectamos la referencia del jugador en cada estado hijo
	for child_state: State in get_children():
		child_state.player = player_ref
		child_state.switch_state.connect(change_state)

	# 3. Una vez asignado 'player', activamos el estado inicial de forma segura

	change_state(initial_state)
	
func _process(delta: float) -> void:
	if active_state:
		active_state.update(delta)
	
func _physics_process(delta: float) -> void:
	if active_state:
		active_state.physics_update(delta)
	
		
func change_state(new_state: State) -> void:
	if new_state == active_state:
		return
		
	if active_state:
		active_state.exit_state()
	
	active_state = new_state
	
	if active_state:
		active_state.enter_state()
	
	
	
