# SPDX-FileCopyrightText: 2026 Tirth Kavathiya <tirthkavathiya@gmail.com>
#
# SPDX-License-Identifier: GPL-3.0-or-later

extends Node2D

const SHIP_SCENE = preload("uid://citcq11bhhs0b")
const HUD_SCENE = preload("uid://bxqmq7s5w4g2")
const HUD_SIZE := Vector2(160.0, 96.0)

var ppos : Array[Vector2] = []
var hpos : Array[Vector2] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SoundManager.play_music()
	Spawner.ship_respawned.connect(_on_ship_respawned)
	
	var view := get_viewport_rect().size
	var quad := view * 0.20
	var third_quad := view * 0.80
	ppos = [quad,third_quad,Vector2(third_quad.x, quad.y),Vector2(quad.x, third_quad.y)]
	hpos = [Vector2.ZERO,view - HUD_SIZE,Vector2(view.x - HUD_SIZE.x, 0.0),Vector2(0.0, view.y - HUD_SIZE.y)]
	
	for i in range(Global.players.size()):
		var player: Player = Global.players[i]
		var new_ship := SHIP_SCENE.instantiate() as RigidBody2D
		var hud := HUD_SCENE.instantiate() as Control
		new_ship.player = player
		new_ship.global_position = ppos[i]
		hud.global_position = hpos[i]
		get_tree().current_scene.add_child(new_ship)
		get_tree().current_scene.add_child(hud)
		hud.initialize(new_ship)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_ship_respawned(ship : RigidBody2D):
	ship.hud.initialize(ship)
