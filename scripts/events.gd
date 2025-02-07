extends Node

enum Pickups {APPLE, ELIXIR, COIN}

# Warning due to the signal not being used directly in the class
@warning_ignore("unused_signal")
signal pickup_collected(type: Pickups)
signal checkpoint_reached
signal player_died(player: Player)
signal player_fell_out_of_world(damage: int)
