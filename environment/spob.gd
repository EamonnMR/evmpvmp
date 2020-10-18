extends Node2D

export var spob_id: String
var landing
export var spob_type: String
export var kind: String
export var biome: String
export var desc: String
export var commodities: Dictionary
export var faction: String
export var landable: bool

# Things it gets from the corresponding spob_type directly (if available)
var SPOB_STATS = [
	"kind",
	"biome",
	"landing",
]

func _ready():
	_apply_stats()
	
func _data():
	return Game.spob_types[spob_type]

func _apply_stats():
	for stat in SPOB_STATS:
		if _data()[stat] and not get(stat):
			set(stat, _data()[stat])
	if not $Sprite.texture:
		$Sprite.texture = _data()["sprite"]
	landable = not (_data()["noland"] == "TRUE")

func add_selection():
	$Sprite.add_child(preload("res://interface/hud/Selection.tscn").instance())

func remove_selection():
	if $Sprite/Selection:
		$Sprite.remove_child($Sprite/Selection)
