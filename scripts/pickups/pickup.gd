class_name Pickup
extends Area2D

func _on_body_entered(_body: Node2D) -> void:
	queue_free()
	execute_effect()

func execute_effect() -> void:
	pass 
