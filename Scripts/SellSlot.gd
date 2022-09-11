extends Panel

var default_tex = preload("res://Assets/Pixel Platformer Blocks/Tiles/Stone/tile_0040.png")
var empty_tex = preload("res://Assets/Pixel Platformer Blocks/Tiles/Stone/tile_0043.png")
var selected_tex = preload("res://Assets/Pixel Platformer Blocks/Tiles/Marble/tile_0043.png")

var default_style: StyleBoxTexture = null
var empty_style: StyleBoxTexture = null
var selected_style: StyleBoxTexture = null

var weapon = null
var slot_index

func _ready():
	default_style = StyleBoxTexture.new()
	empty_style = StyleBoxTexture.new()
	selected_style = StyleBoxTexture.new()
	default_style.texture = default_tex
	empty_style.texture = empty_tex
	selected_style.texture = selected_tex
	refresh_style()

func refresh_style():
#	if SlotType.WEAPON == slotType and PlayerInventory.active_weapon_slot == slot_index:
#		set("custom_styles/panel", selected_style)
	if weapon == null:
		set("custom_styles/panel", empty_style)
	else:
		set("custom_styles/panel", default_style)

func initialize_weapon(w):
	if weapon == null:
		weapon = w
		weapon.position = Vector2(0,0)
		add_child(weapon)
		weapon.set_weapon(w)
	else:
		weapon.set_weapon(w)
	refresh_style()


func _on_Panel_mouse_entered():
	if weapon:
		get_tree().root.get_node("Master/UserInterface/AuctionHouse/Infos/Description").text = get_tree().root.get_node("Master/UserInterface/AuctionHouse").description(weapon)


func _on_Panel_mouse_exited():
	get_tree().root.get_node("Master/UserInterface/AuctionHouse/Infos/Description").text = ""
