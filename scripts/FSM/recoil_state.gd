extends State

@export var idle_state: State
@export var move_state: State

@export_group("Parámetros de Recoil")
@export var duration: float = 1.5             # Segundos de stun (sin control del jugador)
@export var x_deceleration: float = 600.0     # Qué tan rápido se frena en horizontal

var _timer := 0.0


func enter_state() -> void:
	_timer = duration
	# stop() + play() reinicia la animación desde el primer frame en cada disparo
	player.animated_sprite_2d.stop()
	player.animated_sprite_2d.play("recoil_")


func physics_update(delta: float) -> void:
	_timer -= delta

	# Gravedad (el recoil lo lanza, así que puede estar en el aire)
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta

	# Frenado horizontal. Acá NO se lee el input: eso es el stun.
	player.velocity.x = move_toward(player.velocity.x, 0.0, x_deceleration * delta)
	player.move_and_slide()

	# Terminó el stun: volver a idle o a move según el input
	if _timer <= 0.0:
		if Input.get_axis("move_left", "move_right") != 0.0 and move_state:
			switch_state.emit(move_state)
		elif idle_state:
			switch_state.emit(idle_state)
