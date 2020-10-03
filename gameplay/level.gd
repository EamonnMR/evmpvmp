extends Node2D

var WAIT_TIME = 5

# handle NPC spawning and despawning
# TODO: Maybe handle this in enter/exit system funcs on the server?
# Maybe despawn empty systems?
func _physics_process(delta):
	# TODO: This belongs in a timer
	if is_network_master():
		if $players.get_children().size() > 0:
			if $npcs.get_children().size() < 1:
				print("System: ", get_node("../").name, " needs an NPC, spawning it")
				Server.spawn_npc(get_node("../").name)
		else:
			for child in $npcs.get_children():
				$npcs.remove_child(child)
				child.queue_free()

func get_player_entity(player_id):
	return $players.get_node(str(player_id))

func serialize():
	var children = {}
	for child in [
		"shots",
		"players",
		"npcs"
	]:
		children[child] = get_each_serialized(get_node(child))
	return children
	
func get_each_serialized(node):
	var list = []
	for child in node.get_children():
		list.append({
			"name": child.name,
			"scene": child.filename,
			"state": child.serialize()
		})
	return list

func deserialize(data):
	for key in data.keys():
		var node = get_node(key)
		for serial_data in data[key]:
			receive_entity(key, serial_data)

func receive_entity(destination, serial_data):
	var node = get_node(destination)
	print("serial_data: ", serial_data)
	# TODO: Is `load` the smartest thing to use here?
	var object = load(serial_data["scene"]).instance()
	object.deserialize(serial_data["state"])
	object.name = serial_data["name"]
	node.add_child(object)

func remove_entity(destination, name):
	var node = get_node(destination)
	var node_to_remove = get_node(name)
	node.remove_child(node_to_remove)

func get_player_ids():
	var ids = []
	for node in $players.get_children():
		ids.append(int(node.name))
	return ids

func add_effect( effect ):
	$effects.add_child(effect)

