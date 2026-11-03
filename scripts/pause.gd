extends Control

@onready var grid_container := $GridContainer
@onready var normfont : FontFile = preload("res://assets/fonts/pixelated/SFPixelate.ttf")
@onready var boldfont : FontFile = preload("res://assets/fonts/pixelated/SFPixelate-Bold.ttf")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		var tmp = not get_tree().paused
		if tmp:
			await RenderingServer.frame_post_draw
			var image := get_viewport().get_texture().get_image()
			image.convert(Image.FORMAT_RGBA8)
			image.linear_to_srgb()
			image.resize(384, 384)
			$TextureRect.texture = ImageTexture.create_from_image(image)
			
			for child in grid_container.get_children():
				child.queue_free()
			
			var headers = ["Player", "Kills", "Deaths", "Avg. Life", "Max. Life"]
			
			for h in headers:
				var lbl = Label.new()
				lbl.text = h
				lbl.add_theme_font_size_override("font_size", 24)
				lbl.add_theme_font_override("font", boldfont)
				lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
				lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
				grid_container.add_child(lbl)
			
			for i in Global.PLAYERS:
				var player_data = Global.players[i]
				
				var row_values = [
					str(player_data.name),
					str(player_data.kills),
					str(player_data.deaths),
					str(snapped(player_data.avg_life / 60.0, 0.1)) + "m",
					str(snapped(player_data.max_life / 60.0, 0.1)) + "m"
				]
				
				var col = player_data.color
				
				for val in row_values:
					var lbl = Label.new()
					lbl.text = val
					lbl.add_theme_color_override("font_color", col)
					lbl.add_theme_font_size_override("font_size", 18)
					lbl.add_theme_font_override("font", normfont)
					lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
					lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
					grid_container.add_child(lbl)
		
		get_tree().paused = tmp
		visible = tmp
		
func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
