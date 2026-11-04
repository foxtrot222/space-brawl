# SPDX-FileCopyrightText: 2026 Tirth Kavathiya <tirthkavathiya@gmail.com>
#
# SPDX-License-Identifier: GPL-3.0-or-later

extends Node

signal ship_respawned(ship: RigidBody2D)

const SHIP_SCENE = preload("uid://citcq11bhhs0b")
const BULLET_SCENE = preload("uid://cin2ioskvfdc7")
const MISSILE_SCENE = preload("uid://bypkrlqddq6yb")

func respawn_ship(ship: RigidBody2D) -> void:
	if ship == null:
		return
	var player: Player = ship.player
	var hud : Control = ship.hud
	Global.explosion.boom(ship.position, player.color, "ShipExplode")
	ship.queue_free()

	var game_scene := get_tree().current_scene

	await get_tree().create_timer(2.0, false).timeout

	if not is_instance_valid(game_scene) or game_scene != get_tree().current_scene:
		return
	if not is_instance_valid(Global.star) or not is_instance_valid(hud):
		return

	var new_ship := SHIP_SCENE.instantiate() as RigidBody2D
	new_ship.player = player
	new_ship.health = new_ship.MAX_HEALTH
	new_ship.birth = false
	new_ship.ghost = true
	new_ship.hud = hud
	new_ship.position = Global.randcc(200.0)
	new_ship.rotation = randf_range(0.0, TAU)
	game_scene.add_child(new_ship)

	ship_respawned.emit(new_ship)

func spawn_bullet(start_position: Vector2, start_direction: Vector2, shooter : Player) -> void:
	var bullet := BULLET_SCENE.instantiate()
	bullet.setup(start_position, start_direction, shooter)
	get_tree().current_scene.add_child(bullet)

func spawn_missile(target : RigidBody2D, start_position: Vector2, start_direction: Vector2, shooter : Player) -> void:
	var missile := MISSILE_SCENE.instantiate()
	missile.setup(target, start_position, start_direction, shooter)
	get_tree().current_scene.add_child(missile)
