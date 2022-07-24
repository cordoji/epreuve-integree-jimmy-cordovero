extends Node

const SlotClass = preload("res://Scripts/Slot.gd")
const WeaponClass = preload("res://Scripts/Weapon.gd")
const NUM_INVENTORY_SLOTS = 60

var inventory = {}

func add_weapon(weapon_name):
	for i in range(NUM_INVENTORY_SLOTS):
		if inventory.has(i) == false:
			inventory[i] = [weapon_name]
			return

func remove_weapon(slot: SlotClass):
	inventory.erase(slot.slot_index)

func add_weapon_to_empty_slot(weapon: WeaponClass, slot: SlotClass):
	inventory[slot.slot_index] = [weapon.weapon_name]
