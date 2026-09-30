extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var recoil_state: State = $StateMachine/recoil

const RECOIL = 550.0
const RECOIL_DECELERATION = 105.0
# SIN USAR por ahora

const MAX_AMMO := 2
var ammo := MAX_AMMO

const RECOIL_JUMP = 80.0
const RECOIL_UPWARD = 200.0

var recoil_velocity := 0.0
var last_move_direction: float = 0.0


func _physics_process(_delta: float) -> void:
	# El movimiento horizontal, el salto, la gravedad y el stun del recoil
	# los manejan los estados (Idle, Move, Jump, Recoil).
	# Acá solo va apuntar y disparar.

	# Recoil residual
	velocity.x += recoil_velocity
	recoil_velocity = move_toward(recoil_velocity, 0, RECOIL_DECELERATION)

	# Girar el sprite según la posición del mouse
	var mouse_pos := get_global_mouse_position()
	var mira_izquierda := mouse_pos.x < global_position.x
	animated_sprite_2d.flip_h = mira_izquierda

	# Vector desde el jugador hasta el cursor (dirección de apuntado)
	var mouse_direction := mouse_pos - global_position

	# La escopeta mira directamente al cursor
	$Shotgun.look_at(mouse_pos)

	# Corrige la posición del arma según el ángulo respecto del eje x
	var angle := mouse_direction.angle()
	var amount: float = clamp(sin(angle), 0.0, 1.0)
	$Shotgun.position.y = lerp(0.0, -20.0, amount)

	# Evita que la escopeta quede boca abajo al mirar hacia la izquierda
	$Shotgun.scale.y = -1 if mira_izquierda else 1

	# Disparo
	if Input.is_action_just_pressed("Shoot"):
		var shoot_direction := mouse_direction.normalized()

		# Si está en el piso y apunta hacia abajo, reducir el recoil
		var recoil_multiplier := 1.0
		if is_on_floor() and shoot_direction.y > 0.5:
			recoil_multiplier = 0.2

		# Recoil en dirección contraria al disparo
		velocity = -shoot_direction * RECOIL * recoil_multiplier

		# Animación de disparo del cañón
		$Shotgun.shoot(shoot_direction)

		# Pasar al estado de recoil (o reiniciarlo si ya estaba en él)
		if $StateMachine.active_state == recoil_state:
			recoil_state.enter_state()
		else:
			$StateMachine.change_state(recoil_state)
