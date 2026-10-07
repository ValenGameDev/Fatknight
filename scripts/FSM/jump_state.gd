extends State

@export var move_state: State
@export var idle_state: State

@export_group("Anticipación")
@export var min_jump_delay: float = 0.03  # delay si viene casi parado
@export var max_jump_delay: float = 0.18  # delay si viene a toda carrera

@export_group("Parámetros de Salto")
@export var jump_velocity: float = -300.0   # Impulso inicial (negativo = hacia arriba)
@export var rise_gravity_scale: float = 1.2 # Multiplicador de gravedad mientras sube
@export var fall_gravity_scale: float = 1.9 # Multiplicador de gravedad mientras cae
@export_group("Salto largo")
@export var min_horizontal_boost: float = 5.0
@export var max_horizontal_boost: float = 120.0 # impulso horizontal extra al despegar

@export_group("Movimiento en el aire")
@export var air_speed: float = 2.0
@export var air_acceleration: float = 25.0

var _windup_timer := 0.0
var _windup_duration := 0.0
var _has_launched := false
var _launch_velocity_x := 0.0
var _jump_direction := 0.0

	
func enter_state() -> void:
	var direction := Input.get_axis("move_left", "move_right")
	var speed_ratio: float = clamp(abs(player.velocity.x) / move_state.speed, 0.0, 1.0)
	_jump_direction = direction
	
		
	if direction == 0.0:
		_launch_velocity_x = 0.0
	elif sign(direction) == sign(player.last_move_direction) or player.last_move_direction == 0.0:
		var boost := lerpf(min_horizontal_boost, max_horizontal_boost, speed_ratio)
		_launch_velocity_x = direction * boost
	else:
		# TO DO: backflip
		_launch_velocity_x = 0.0
	# animación de salto
	
	_windup_duration = lerpf(min_jump_delay, max_jump_delay, speed_ratio)
	_windup_timer = 0.0
	_has_launched = false
	_update_animation()

	#player.velocity.x = 0.0



func physics_update(delta: float) -> void:
	_update_animation()
	if not _has_launched:
		_windup_timer += delta
		player.velocity.x = move_toward(
			player.velocity.x,
			0.0,
			air_acceleration * delta
		)
		player.move_and_slide()
		if _windup_timer >= _windup_duration:
			_launch()
		return
	var gravity_scale := rise_gravity_scale if player.velocity.y < 0.0 else fall_gravity_scale
	player.velocity += player.get_gravity() * gravity_scale * delta

	var direction := Input.get_axis("move_left", "move_right")
	player.velocity.x = move_toward(player.velocity.x, direction * air_speed, air_acceleration * delta)

	player.move_and_slide()

	if player.is_on_floor():
		if direction != 0.0 and move_state:
			switch_state.emit(move_state)
		elif idle_state:
			switch_state.emit(idle_state)
			

func _launch() -> void:
	_has_launched = true
	player.velocity.y = jump_velocity
	player.velocity.x = _launch_velocity_x
	# animación de despegue
	
func _update_animation() -> void:
	var sprite: AnimatedSprite2D = player.animated_sprite_2d
	if _jump_direction == 0.0:
		sprite.play("idle")
		return
	var apunta_izquierda := player.get_global_mouse_position().x < player.global_position.x
	var corre_izquierda := _jump_direction < 0.0
	if apunta_izquierda != corre_izquierda:
		sprite.flip_h = corre_izquierda
		sprite.play("reverse_run")
	else:
		sprite.play("Run")
