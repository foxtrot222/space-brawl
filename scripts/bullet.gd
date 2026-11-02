# SPDX-FileCopyrightText: 2026 Tirth Kavathiya <tirthkavathiya@gmail.com>
#
# SPDX-License-Identifier: GPL-3.0-or-later

extends Area2D

const BULLET_SPEED := 1500.0
const BULLET_DAMAGE := 5

var velocity: Vector2
var shooter: Player
var color : Color

func setup(start_position: Vector2, start_direction: Vector2, player : Player) -> void:
	global_position = start_position
	velocity = start_direction.normalized() * BULLET_SPEED
	rotation = start_direction.angle()
	shooter = player
	color = shooter.color
	$Line2D.default_color = color

func _physics_process(delta: float) -> void:
	global_position += velocity * delta
	rotation = velocity.angle()

func _on_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		if body.player == shooter:
			return
		body.take_damage(BULLET_DAMAGE, shooter)
		var pos = position
		if $ShapeCast2D.get_collision_count():
			pos = $ShapeCast2D.get_collision_point(0)
		Global.explosion.boom(pos, color, "BulletExplode")
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	var pos = position
	if $ShapeCast2D.get_collision_count():
		pos = $ShapeCast2D.get_collision_point(0)
	if area.name == "KillZone":
		Global.explosion.boom(pos, color, "BulletExplode")
		queue_free()
	if area.name == "Bullet":
		Global.explosion.boom(pos, color, "BulletExplode")
		Global.explosion.boom(pos, area.color, "BulletExplode")
		area.queue_free()
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
