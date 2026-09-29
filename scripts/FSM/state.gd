class_name State extends Node

@warning_ignore("unused_signal")
signal switch_state(state : State)

var player: CharacterBody2D


func enter_state() -> void:
	pass
	
func exit_state() -> void: 
	pass
	
func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass
	
		
