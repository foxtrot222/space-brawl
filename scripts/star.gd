# SPDX-FileCopyrightText: 2026 Tirth Kavathiya <tirthkavathiya@gmail.com>
#
# SPDX-License-Identifier: GPL-3.0-or-later

extends Node2D

var GRAVITY_STRENGTH := 500000.0
const ROTATE_FACTOR := 5

func _ready() -> void:
	GRAVITY_STRENGTH = Global.GRAVITY_STRENGTH
	Global.set_star(self)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		body.take_damage(1000)

func _process(delta: float) -> void:
	$Sprite2D.rotate(deg_to_rad(ROTATE_FACTOR) * delta)
