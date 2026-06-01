extends Node

var start_screen: PackedScene = preload("res://ui/screens/StartScreen.tscn")
var end_screen: PackedScene = preload("res://ui/screens/EndScreen.tscn")
var jelly: PackedScene = preload("res://game/characters/Jelly.tscn")
var main_scene: PackedScene = preload("res://game/scene/MainScene.tscn")
var idea: PackedScene = preload("res://game/elements/Idea.tscn")
var creation: PackedScene = preload("res://game/elements/Creation.tscn")
var control_hint: PackedScene = preload("res://ui/screens/ControlHint.tscn")

var bad_creations: Array = [
	preload("res://enemies/BadPaperFish.tscn"),
	preload("res://enemies/BadMSPaintFish.tscn"),
	preload("res://enemies/BadValFish.tscn")
]

var normal_creations: Array = [
	preload("res://enemies/PaperFish.tscn"),
	preload("res://enemies/MSPaintFish.tscn"),
	preload("res://enemies/ValFish.tscn")
]
