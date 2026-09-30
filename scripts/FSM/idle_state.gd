extends State

@export var move_state: State
@export var jump_state: State

@export_group("Parámetros de Frenado")
@export var friction: float = 300.0 # Qué tan rápido llega a 0


func enter_state() -> void:
	player.animated_sprite_2d.play("idle")
	#play animation

func physics_update(delta: float) -> void:
	
	if Input.is_action_just_pressed("salto") and jump_state and player.is_on_floor():
		switch_state.emit(jump_state)
		return
	
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta

	var direction := Input.get_axis("move_left", "move_right")
	if direction != 0.0:
		if move_state:
			switch_state.emit(move_state)
		return

	player.velocity.x = move_toward(player.velocity.x, 0, friction * delta)
	player.move_and_slide()
	

#
#func update(_delta: float) -> void:
	#if Input.get_vector("move_left", "move_right", "ui_up", "ui_down") != Vector2.ZERO:
		#switch_state.emit(move_state)
#
#
		#
	#
 
