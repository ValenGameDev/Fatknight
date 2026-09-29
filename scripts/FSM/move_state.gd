extends State

@export var idle_state: State
@export var jump_state: State

@export_group("Parámetros de Movimiento")
@export var speed: float = 70.0
@export var acceleration: float = 200.0



func enter_state() -> void:
	#Animacion
	pass	
	
func physics_update(delta: float) -> void:

	
	# 1. Chequeo el input de salto
	if Input.is_action_just_pressed("salto") and jump_state:
		switch_state.emit(jump_state)
		return
		
	# 2. Mantener la gravedad activa para no flotar si cae de una plataforma
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta
		
	# 3. Leer Input del usuario
	var direction := Input.get_axis("move_left", "move_right")
	
	if abs(player.velocity.x) > 5.0:
		player.last_move_direction = sign(player.velocity.x)  # detecta si hubo un cambio repentino de dirección
	
	# 4. Si soltó las teclas, pasa el control a Idle
	if direction == 0.0:
		if idle_state:
			switch_state.emit(idle_state)
		return
	
	var target_velocity := direction * speed
	player.velocity.x = move_toward(player.velocity.x, target_velocity, acceleration * delta)
	player.move_and_slide()
	print("entré!")
	
	

#func update(_delta: float) -> void:
	#if Input.get_vector("move_left", "move_right", "ui_up", "ui_down") == Vector2.ZERO:
		#switch_state.emit(idle_state)








		
	
