# SPDX-FileCopyrightText: 2026 Tirth Kavathiya <tirthkavathiya@gmail.com>
#
# SPDX-License-Identifier: GPL-3.0-or-later

extends Node

func qj():
	$QJ.play()

func fire_bullet():
	$FireBullet.play()
	
func fire_missile():
	$FireMissile.play()
	
func ghost():
	$Ghost.play()

func collision():
	$Collision.play()
	
func boom(expsn : String):
	get_node(expsn).play()

func play_music() -> void:
	$"8BitSpaceshooter".stream_paused = false
	$"8BitSpaceshooter".play()

func stop_music() -> void:
	$"8BitSpaceshooter".stop()
	$"8BitSpaceshooter".stream_paused = false

func pause_music() -> void:
	$"8BitSpaceshooter".stream_paused = true

func resume_music() -> void:
	$"8BitSpaceshooter".stream_paused = false
