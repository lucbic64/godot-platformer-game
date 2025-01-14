extends Pickup

func execute_effect() -> void:
	Events.pickup_collected.emit(Events.Pickups.ELIXIR)
