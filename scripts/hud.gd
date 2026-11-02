# SPDX-FileCopyrightText: 2026 Tirth Kavathiya <tirthkavathiya@gmail.com>
#
# SPDX-License-Identifier: GPL-3.0-or-later

extends Control

@export var color : Color
@onready var ship : RigidBody2D

var max_laser := 0.0
var max_health := 0.0
var missiles : Array[ColorRect]

var back := 0.118
var front :=  0.784

func _ready() -> void:
	missiles.resize(4)

func _process(_delta: float) -> void:
	if not is_instance_valid(ship):
		visible = false
		return
	visible = not ship.ghost
	$HealthBar.size.x = scale(ship.health, 0.0, 128.0, max_health)
	$LaserBar.size.x = scale(ship.laser.laser_cooldown, 0.0, 64.0, max_laser)
	$QJ.modulate.a = front if ship.qj_cooldown else back
	$Target.modulate.a = front if ship.target != null else back
	match ship.equipped_weapon:
		ship.Weapon.BULLET:
			$Bullet.modulate.a = front
			$Laser.modulate.a = back
			$HMissile.modulate.a = back
		ship.Weapon.MISSILE:
			$HMissile.modulate.a = front
			$Bullet.modulate.a = back
			$Laser.modulate.a = back
		ship.Weapon.LASER:
			$Laser.modulate.a = front
			$Bullet.modulate.a = back
			$HMissile.modulate.a = back
	for i in missiles.size():
		missiles[i].modulate.a = ( front if i < ship.missile_slots else back )

func initialize(p : RigidBody2D):
	ship = p
	ship.hud = self
	color = ship.player.color
	var j = 0
	for i in get_children():
		i.modulate = Color(color.r, color.g, color.b, i.modulate.a)
		if i.name.begins_with("Missile"):
			missiles[j] = i
			j += 1
	max_laser = ship.laser.MAX_LASER_TIME
	max_health = ship.MAX_HEALTH

func scale(x : float, a : float, b : float, mx : float) -> float:
	return a + ( x * (b - a) ) / mx
