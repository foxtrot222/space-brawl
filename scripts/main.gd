extends Node2D

const PLAYER_SCENE = preload("res://scenes/player.tscn")
const HUD_SCENE = preload("res://scenes/hud.tscn")

var players : Array[Color] = Global.players
var ppos : Array[Vector2] = []
var hpos : Array[Vector2] = []
const HUD_SIZE := Vector2(160.0, 96.0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var view := get_viewport_rect().size
	var quad := view * 0.25
	var third_quad := view * 0.75
	ppos = [quad,third_quad,Vector2(third_quad.x, quad.y),Vector2(quad.x, third_quad.y)]
	hpos = [Vector2.ZERO,view - HUD_SIZE,Vector2(view.x - HUD_SIZE.x, 0.0),Vector2(0.0, view.y - HUD_SIZE.y)]
	
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
		hud.initialize(new_player)
	Spawner.player_respawned.connect(_on_player_respawned)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_player_respawned(player : RigidBody2D):
	player.hud.initialize(player)
