extends Camera2D

@export_group("Mirar hacia el cursor")
@export var max_offset := Vector2(60.0, 35.0)  # Cuánto se puede desplazar la cámara (px) en X e Y
@export var smoothing: float = 8.0             # Más alto = la cámara responde más rápido


func _process(delta: float) -> void:
	var viewport := get_viewport()
	var half_size := viewport.get_visible_rect().size / 2.0

	# Posición del mouse relativa al centro de la pantalla, normalizada entre -1 y 1
	var from_center := (viewport.get_mouse_position() - half_size) / half_size
	from_center = from_center.clamp(Vector2(-1.0, -1.0), Vector2(1.0, 1.0))

	# Hacia dónde queremos desplazar la cámara
	var target_offset := from_center * max_offset

	# Interpolación suave, independiente del framerate
	offset = offset.lerp(target_offset, 1.0 - exp(-smoothing * delta))
