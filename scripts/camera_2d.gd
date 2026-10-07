extends Camera2D

@export_group("Mirar hacia el cursor")
@export var max_offset := Vector2(60.0, 35.0)
@export var smoothing: float = 8.0

@export_group("Expansión al disparar")
@export var shot_zoom_out: float = 0.15       # Cuánto se aleja (0.15 = ~15% más de mapa visible)
@export var zoom_out_speed: float = 20.0      # Qué tan rápido se expande al disparar
@export var zoom_return_speed: float = 0.4    # Qué tan lento vuelve (más bajo = tarda más)

var _base_zoom := Vector2.ONE
var _kick_target := 0.0
var _kick := 0.0


func _ready() -> void:
	_base_zoom = zoom


# La llama el jugador cada vez que dispara
func shot_kick() -> void:
	_kick_target = shot_zoom_out


func _process(delta: float) -> void:
	# --- Mirar hacia el cursor ---
	var viewport := get_viewport()
	var half_size := viewport.get_visible_rect().size / 2.0
	var from_center := (viewport.get_mouse_position() - half_size) / half_size
	from_center = from_center.clamp(Vector2(-1.0, -1.0), Vector2(1.0, 1.0))
	var target_offset := from_center * max_offset
	offset = offset.lerp(target_offset, 1.0 - exp(-smoothing * delta))

	# --- Expansión al disparar ---
	# El objetivo decae solo hacia 0 y el valor real lo sigue suavemente
	_kick_target = move_toward(_kick_target, 0.0, zoom_return_speed * delta)
	_kick = lerpf(_kick, _kick_target, 1.0 - exp(-zoom_out_speed * delta))
	zoom = _base_zoom * (1.0 - _kick)
