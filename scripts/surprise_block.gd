extends StaticBody2D

@export var activated_img: Vector2

@onready var player_detection = $PlayerDetection
@onready var coin = preload("res://scenes/pickups/coin.tscn")
@onready var elixir = preload("res://scenes/pickups/elixir.tscn")
@onready var apple = preload("res://scenes/pickups/apple.tscn")

var activated = false

func _process(_delta: float) -> void:
	if player_detection.has_overlapping_bodies():
		var player = player_detection.get_overlapping_bodies()[0] as Player
		
		if player.state_machine.current_state is Jump and not activated: activate_block()

func activate_block() -> void:
	var choices: Array[PackedScene] = [coin, elixir, apple]
	var object: Pickup = choices.pick_random().instantiate()
	add_child(object)
	
	object.position = Vector2(8, -8)
	
	$BlockSprite.region_rect.position += activated_img
	activated = true
