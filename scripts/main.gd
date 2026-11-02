extends Node2D

const PLAYER_SCENE = preload("res://scenes/player.tscn")
const HUD_SCENE = preload("res://scenes/hud.tscn")

var players : Array[Color] = Global.players
var ppos : Array[Vector2] = [Vector2(256.0, 256.0), Vector2(768.0, 768.0), Vector2(768.0, 256.0), Vector2(256.0, 768.0)]
var hpos : Array[Vector2] = [Vector2(0.0, 0.0), Vector2(864.0, 928.0), Vector2(864.0, 0.0), Vector2(0.0, 928.0)]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(Global.players.size()):
		var player_prefix: String = str(i)
		var player_color: Color = Global.players[i]
		var new_player := PLAYER_SCENE.instantiate() as RigidBody2D
		var hud := HUD_SCENE.instantiate() as Control
		hud.name = "HUD" + str(i)
		new_player.player_prefix = player_prefix
		new_player.color = player_color
		new_player.name = "Player" + str(i)
		new_player.global_position = ppos[i]
		hud.global_position = hpos[i]
		get_tree().current_scene.add_child(new_player)
		get_tree().current_scene.add_child(hud)
	
	for i in get_children():
		if i.name.begins_with("HUD"):
			i.initialize(get_node("Player" + str(i.name)[3]))
	Spawner.player_respawned.connect(_on_player_respawned)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_player_respawned(player : RigidBody2D):
	player.hud.initialize(player)
