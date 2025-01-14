class_name State
extends Node

@export var animation_name: String

var parent: Player

func enter() -> void:
	parent.player_sprite.play(animation_name)

func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	return null
