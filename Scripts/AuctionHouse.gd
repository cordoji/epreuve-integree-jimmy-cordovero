extends Node2D

const SellSlotClass = preload("res://Scripts/SellSlot.gd")

const WeaponClass = preload("res://Scripts/Weapon.gd")
const NUM_SELL_SLOTS = 60

onready var inventory_sellSlots = $GridContainer

var sellList = {}

func _ready():
	var sell_slots = inventory_sellSlots.get_children()
	for i in range (sell_slots.size()):
		sell_slots[i].connect("gui_input", self, "sell_gui_input", [sell_slots[i]])
		sell_slots[i].slot_index = i

func slot_gui_input(event: InputEvent, slot: SellSlotClass):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			pass
	return

func _on_Sell_toggled(button_pressed):
	$GridContainer.visible = !$GridContainer.visible

func initialize_sellables():
	var sellSlots = inventory_sellSlots.get_children()
	for i in range(sellSlots.size()):
		if PlayerInventory.inventory.has(i):
			sellSlots[i].initialize_weapon(PlayerInventory.inventory[i][0])
#	for i in range(PlayerInventory.inventory.size()):
#		print(PlayerInventory.inventory[i][0].position)

func reset_sellables():
	var sellSlots = inventory_sellSlots.get_children()
	for i in range(sellSlots.size()):
		delete_children(sellSlots[i])
		sellSlots[i].weapon = null
		sellSlots[i].refresh_style()

static func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
