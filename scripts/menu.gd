# SPDX-FileCopyrightText: 2026 Tirth Kavathiya <tirthkavathiya@gmail.com>
#
# SPDX-License-Identifier: GPL-3.0-or-later

extends Control

const CREDITS_SCENE := "uid://b5jc8io0au1d8"

@onready var nodes := [$P1, $P2, $P3, $P4]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SoundManager.stop_music()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		get_viewport().set_input_as_handled()
		_on_play_pressed()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $OptionButton.get_selected_id() == 3:
		$P3.visible = true
		$P4.visible = false
	elif $OptionButton.get_selected_id() == 4:
		$P3.visible = true
		$P4.visible = true
	else:
		$P3.visible = false
		$P4.visible = false
	Global.PLAYERS = $OptionButton.get_selected_id()
	Global.GRAVITY_STRENGTH = float($TextEdit.text)
	Global.ENABLE_ANGULAR_INERTIA = $CheckButton.button_pressed
	
	$Warning.visible = false
	for i in range(Global.PLAYERS):
		for j in range(i + 1, Global.PLAYERS):
			if nodes[i].get_node("Controls").get_selected_id() == nodes[j].get_node("Controls").get_selected_id() || nodes[i].get_node("Color").color == nodes[j].get_node("Color").color:
				$Warning.add_theme_color_override("font_color", nodes[i].get_node("Color").color)
				$Warning.visible = true
	
func _on_play_pressed() -> void:
	Global.players.resize(Global.PLAYERS)
	for i in Global.PLAYERS:
		var player := Player.new()
		player.prefix = str(nodes[i].get_node("Controls").get_selected_id())
		player.color = nodes[i].get_node("Color").color
		player.name = nodes[i].get_node("Name").text
		Global.players[i] = player
	get_tree().change_scene_to_file("uid://ck244wsn1nj50")


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file(CREDITS_SCENE)
