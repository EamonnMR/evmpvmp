extends Node2D

var DISPOSITION_COLORS = {
	"hostile": Color(1,0,0),
	"neutral": Color(0,0,1),
	"abandoned": Color(0.2,0.2,0.2)
}

func dat():
	return get_node("../").data

func get_map():
	# system -> systems -> panel -> map
	return get_node("../../../../")

func get_color():
	var mode = get_map().get_node("Mode").selected
	if mode == 0:
		return DISPOSITION_COLORS["neutral"]
	if mode == 1:
		var distance = dat()["distance_normalized"]
		var brightness = 1 - ((distance * 0.9) + 0.1)
		return Color(brightness, brightness, brightness)
	if mode == 2:
		if "faction" in dat():
			Game.factions[dat()["faction"]]["color"]
		else:
			return Color(0.5, 0.5, 0.5)
	return Color(0,0,1)

func _draw():
	if Client.player_input.selected_system == get_node("../").system_id:
		draw_circle(Vector2(0,0), 9, Color(0,1,0))
	
	draw_circle(Vector2(0,0), 7, get_color())
	draw_circle(Vector2(0,0), 5, Color(0,0,0))
	
	if Client.get_level().name == get_node("../").system_id:
		draw_circle(Vector2(0,0), 2, Color(0,1,0))
