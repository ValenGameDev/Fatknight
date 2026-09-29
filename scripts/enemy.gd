extends Node2D
const speed = 60.0 
var direction = 1 
var health = 3
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var enemy: AnimatedSprite2D = $enemy



# Called every frame. 'delta' is the elapsed time since the previous frame.
func take_damage(amount: int):
	health -= amount
	print("Vida del enemigo: ", health)
	
func _process(delta: float) -> void:
	if ray_cast_left.is_colliding():
		direction = -1
		enemy.flip_h = true
		
	if ray_cast_right.is_colliding():
		direction = 1	
		enemy.flip_h = false
		  
	
	
	position.x += speed * delta * direction
	
