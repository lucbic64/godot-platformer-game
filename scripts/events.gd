extends Node

enum Pickups {APPLE, ELIXIR, COIN}

# Warnings due to the signals not being used directly in the class
@warning_ignore("unused_signal")
signal pickup_collected(type: Pickups)

@warning_ignore("unused_signal")
signal checkpoint_reached

@warning_ignore("unused_signal")
signal player_died(player: Player)
