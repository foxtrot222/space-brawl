# SPDX-FileCopyrightText: 2026 Tirth Kavathiya <tirthkavathiya@gmail.com>
#
# SPDX-License-Identifier: GPL-3.0-or-later

extends Node

signal ship_respawned(ship: RigidBody2D)

const SHIP_SCENE = preload("res://scenes/ship.tscn")
const BULLET_SCENE = preload("res://scenes/bullet.tscn")
const MISSILE_SCENE = preload("res://scenes/missile.tscn")

func respawn_ship(ship: RigidBody2D) -> void:
	if ship == null:
		return
	var player: Player = ship.player
	var hud : Control = ship.hud
	Global.explosion.boom(ship.position, player.color, "ShipExplode")
	ship.queue_free()

	await get_tree().create_timer(2.0).timeout
	
	var new_ship := SHIP_SCENE.instantiate() as RigidBody2D
	new_ship.player = player
	new_ship.health = new_ship.MAX_HEALTH
	new_ship.birth = false
	new_ship.ghost = true
	new_ship.hud = hud
	new_ship.position = Global.randcc(200.0)
	new_ship.rotation = randf_range(0.0, TAU)
	get_tree().current_scene.add_child(new_ship)
	
	ship_respawned.emit(new_ship)

func spawn_bullet(start_position: Vector2, start_direction: Vector2, shooter : Player) -> void:
	var bullet := BULLET_SCENE.instantiate()
	bullet.setup(start_position, start_direction, shooter)
	get_tree().current_scene.add_child(bullet)

func spawn_missile(target : RigidBody2D, start_position: Vector2, start_direction: Vector2, shooter : Player) -> void:
	var missile := MISSILE_SCENE.instantiate()
	missile.setup(target, start_position, start_direction, shooter)
	get_tree().current_scene.add_child(missile)
