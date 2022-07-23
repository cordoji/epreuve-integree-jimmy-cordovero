extends Panel

var default_tex = preload("res://Assets/Pixel Platformer Blocks/Tiles/Stone/tile_0040.png")
var empty_tex = preload("res://Assets/Pixel Platformer Blocks/Tiles/Stone/tile_0043.png")

var default_style: StyleBoxTexture = null
var empty_style: StyleBoxTexture = null

var WeaponClass = preload("res://Scenes/Weapon.tscn")
var weapon = null

func _ready():
	default_style = StyleBoxTexture.new()
	empty_style = StyleBoxTexture.new()
	default_style.texture = default_tex
	empty_style.texture = empty_tex
	
	if randi() % 2 == 0:
		weapon = WeaponClass.instance()
		add_child(weapon)
		#weapon.get_node("Sprite").position = Vector2(21,24)
	
	refresh_style()


func refresh_style():
	if weapon == null:
		set("custom_styles/panel", empty_style)
	else:
		set("custom_styles/panel", default_style)

func pickFromSlot():
	remove_child(weapon)
	var inventoryNode = find_parent("Inventory")
	inventoryNode.add_child(weapon)
	weapon = null
	refresh_style()

func putIntoSlot(new_weapon):
	weapon = new_weapon
	weapon.position = Vector2(0,0)
	var inventoryNode = find_parent("Inventory")
	inventoryNode.remove_child(weapon)
	add_child(weapon)
	refresh_style()

