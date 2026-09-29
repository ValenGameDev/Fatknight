extends Area2D

var direction := Vector2.ZERO
var speed := 500.0

## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#area_entered.connect(_on_area_entered)
	## Replace with function body.

#func _on_area_entered(area: Area2D) -> void:
	#var damage = 1 
	#print("Entró un área")
#	area.get_parent().take_damage(damage)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += direction * speed * delta
	

#Elimina de memoria la bala que salió de la pantalla 
func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
