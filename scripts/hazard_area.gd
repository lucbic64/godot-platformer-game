extends Area2D

## The timeframe in seconds till the next damage tick
@export_custom(PROPERTY_HINT_NONE, "suffix:s") var damage_interval: float
## The damage done to the player each damage tick
@export_custom(PROPERTY_HINT_NONE, "suffix:dmg/tick") var damage_points: int

@onready var damage_timer = $DamageTimer

var player: Player

func _on_body_entered(body: Node2D) -> void:
	damage_timer.start(damage_interval)
	player = body

func _on_body_exited(_body: Node2D) -> void:
	damage_timer.stop()

func _on_damage_timer_timeout() -> void:
	player.damage(damage_points)
