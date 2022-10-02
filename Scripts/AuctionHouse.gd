extends Node2D

var auctioned_item_scene = preload("res://Scenes/AuctionedItem.tscn")

const SellSlotClass = preload("res://Scripts/SellSlot.gd")
const WeaponClass = preload("res://Scripts/Weapon.gd")

const NUM_SELL_SLOTS = 60

onready var inventory_sellSlots = $TabContainer/Sell/GridContainer

var selected_weapon
var selected_slot

var sellList = {}

func _ready():
	var sell_slots = inventory_sellSlots.get_children()
	for i in range (sell_slots.size()):
		sell_slots[i].connect("gui_input", self, "sell_gui_input", [sell_slots[i]])
		sell_slots[i].slot_index = i

func sell_gui_input(event: InputEvent, slot: SellSlotClass):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed && slot.weapon:
			$SellWindow.popup_centered()
			selected_weapon = slot.weapon
			selected_slot = slot
			$SellWindow.dialog_text = description(selected_weapon)

func description(weapon):
	var d = "name : " + weapon.weapon_name + "\ndamage : " + str(weapon.damage_modifier * 30) + "\nrate of fire : " + str(1 / weapon.fire_rate)
	return d

#func _on_Sell_toggled(button_pressed):
#	$GridContainer.visible = !$GridContainer.visible
#	$ScrollContainer.visible = !$ScrollContainer.visible


func initialize_sellables():
	var sellSlots = inventory_sellSlots.get_children()
	for i in range(sellSlots.size()):
		if PlayerInventory.inventory.has(i):
			sellSlots[i].initialize_weapon(PlayerInventory.inventory[i][0])

func reset_sellables():
	var sellSlots = inventory_sellSlots.get_children()
	for i in range(sellSlots.size()):
		delete_children(sellSlots[i])
		sellSlots[i].weapon = null
		sellSlots[i].refresh_style()

static func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)

func _on_SellWindow_item_auctioned():
	for i in range(sellList.size() + 1):
		if sellList.has(i) == false:
			sellList[i] = [selected_weapon, $SellWindow.price]
			item_in_slot_auctioned(selected_slot)
			return

func item_in_slot_auctioned(slot):
	create_auction_line(slot.weapon)
	slot.weapon = null
	PlayerInventory.inventory.erase(slot.slot_index)
	delete_children(slot)
	slot.refresh_style()

func initialize_auction_house():
	var item
	for i in range(sellList.size()):
		item = auctioned_item_scene.instance()
		item.description = description(sellList[i][0])
		item.price = sellList[i][1]
		item.weapon_on_auction = sellList[i][0]
		item.seller = sellList[i][2]
		item.sellerid = sellList[i][3]
		item.refresh()
		$TabContainer/Buy/ScrollContainer/VBoxContainer.add_child(item)

func create_auction_line(weapon):
	var item = auctioned_item_scene.instance()
	item.description = $SellWindow.dialog_text
	item.price = $SellWindow.price
	item.weapon_on_auction = weapon
	item.seller = get_tree().root.get_node("Master").username
	item.refresh()
	$TabContainer/Buy/ScrollContainer/VBoxContainer.add_child(item)
