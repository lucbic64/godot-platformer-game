extends Area2D

func _on_body_entered(_body: Node2D) -> void:
	Events.checkpoint_reached.emit()
