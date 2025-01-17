extends Node

enum Pickups {APPLE, ELIXIR, COIN}

# Warning due to the signal not being used directly in the class
@warning_ignore("unused_signal")
signal pickup_collected(type: Pickups)
signal checkpoint_reached
