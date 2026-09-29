extends Node2D
#Variable que pueda contener una escena proyectil
@export var projectile_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func shoot(shot_direction: Vector2):
	var projectile = projectile_scene.instantiate()
	print(projectile)
	print(projectile.get_class())
	$FireShot.stop()
	$FireShot.play("fire")
	get_tree().current_scene.add_child(projectile)
	projectile.global_position = $Muzzle.global_position
	projectile.direction = shot_direction
	
		
	
	

	
