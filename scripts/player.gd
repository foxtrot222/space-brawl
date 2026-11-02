# SPDX-FileCopyrightText: 2026 Tirth Kavathiya <tirthkavathiya@gmail.com>
#
# SPDX-License-Identifier: GPL-3.0-or-later

extends RefCounted
class_name Player

var color : Color
var prefix : String

var kills := 0
var deaths := 0
var avg_life := 0.0
var max_life := 0.0

func died(lifetime : float):
	avg_life = ( lifetime + avg_life * deaths ) / ( deaths + 1 )
	max_life = max(lifetime, max_life)
	deaths += 1
