extends Store

signal player_purchased_upgrade(type, quantity)
signal player_sold_upgrade(type, quantity)

func _physics_process(delta):
	#HACK: Too many things to connect to this.
	# Throw up hands in despair.
	update()

func _enter_tree():
	Client.player_ship.connect("upgrades_updated", self, "update")
	update()
	
func items():
	return Game.upgrades

func _on_BuyButton_pressed():
	emit_signal("player_purchased_upgrade", selected, 1)

func _on_SellButton_pressed():
	emit_signal("player_sold_upgrade", selected, 1)

func get_count(type) -> int:
	return Client.player_ship.upgrades[type] if type in Client.player_ship.upgrades else 0

func update_selection(id):
	.update_selection(id)
	$ItemMass.text = "Mass: " + str(items()[id].mass)
	update_mass_text()

func update():
	.update()
	update_mass_text()

func update_mass_text():
	$FreeMass.text = "Free Mass: " + str(Client.player_ship.free_mass) + " / Total Mass: " + str(Client.player_ship.data().free_mass)
