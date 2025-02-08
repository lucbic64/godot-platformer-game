extends Area2D

var active = false

func _ready() -> void:
	Events.player_died.connect(reset_to_last_checkpoint)
	Events.checkpoint_reached.connect(checkpoint_reached)

func _on_body_entered(_body: Node2D) -> void:
	Events.checkpoint_reached.emit()
	active = true

func checkpoint_reached() -> void:
	active = false

func reset_to_last_checkpoint(player: Player) -> void:
	if active: player.global_position = global_position
