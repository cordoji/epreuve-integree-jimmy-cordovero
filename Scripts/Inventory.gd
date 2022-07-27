extends Node2D

const SlotClass = preload("res://Scripts/Slot.gd")
onready var inventory_slots = $GridContainer
onready var equip_slots = $EquipSlots.get_children()
var holding_weapon = null

func _ready():
	var inv_slots = inventory_slots.get_children()
	for i in range (inv_slots.size()):
		inv_slots[i].connect("gui_input", self, "slot_gui_input", [inv_slots[i]])
		inv_slots[i].slot_index = i
		inv_slots[i].slotType = SlotClass.SlotType.INVENTORY
		
	for i in range(equip_slots.size()):
		PlayerInventory.connect("active_weapon_updated", equip_slots[i], "refresh_style")
		equip_slots[i].connect("gui_input", self, "slot_gui_input", [equip_slots[i]])
		equip_slots[i].slot_index = i
		equip_slots[i].slotType = SlotClass.SlotType.WEAPON
		
	initialize_inventory()
	initialize_equips()

func slot_gui_input(event: InputEvent, slot: SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			if holding_weapon != null:
				if !slot.weapon:
					slot.putIntoSlot(holding_weapon)
					PlayerInventory.add_weapon_to_empty_slot(holding_weapon, slot)
					holding_weapon = null
				else:
					var temp_weapon = slot.weapon
					slot.pickFromSlot()
					PlayerInventory.remove_weapon(slot)
					temp_weapon.global_position = event.global_position
					slot.putIntoSlot(holding_weapon)
					PlayerInventory.add_weapon_to_empty_slot(holding_weapon, slot)
					holding_weapon = temp_weapon
			elif slot.weapon:
				holding_weapon = slot.weapon
				slot.pickFromSlot()
				PlayerInventory.remove_weapon(slot)
				holding_weapon.global_position = get_global_mouse_position()

func _input(_event):
	if holding_weapon:
		holding_weapon.global_position = get_global_mouse_position()

func initialize_inventory():
	var slots = inventory_slots.get_children()
	for i in range(slots.size()):
		if PlayerInventory.inventory.has(i):
			slots[i].initialize_weapon(PlayerInventory.inventory[i][0])

func initialize_equips():
	for i in range(equip_slots.size()):
		if PlayerInventory.equips.has(i):
			equip_slots[i].initialize_weapon(PlayerInventory.equips[i][0])
