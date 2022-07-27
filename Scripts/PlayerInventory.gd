extends Node

signal active_weapon_updated

const SlotClass = preload("res://Scripts/Slot.gd")
const WeaponClass = preload("res://Scripts/Weapon.gd")
const NUM_INVENTORY_SLOTS = 60
const NUM_EQUIP_SLOTS = 5

var inventory = {}
var equips = {}

var active_weapon_slot = 0

func add_weapon(weapon_name):
	for i in range(NUM_INVENTORY_SLOTS):
		if inventory.has(i) == false:
			inventory[i] = [weapon_name]
			return

func remove_weapon(slot: SlotClass):
	match slot.slotType:
		SlotClass.SlotType.INVENTORY:
			inventory.erase(slot.slot_index)
		SlotClass.SlotType.WEAPON:
			equips.erase(slot.slot_index)

func add_weapon_to_empty_slot(weapon: WeaponClass, slot: SlotClass):
	match slot.slotType:
		SlotClass.SlotType.INVENTORY:
			inventory[slot.slot_index] = [weapon.weapon_name]
			if active_weapon_slot == slot.slot_index:
				emit_signal("active_weapon_updated")
		SlotClass.SlotType.WEAPON:
			equips[slot.slot_index] = [weapon.weapon_name]
			if active_weapon_slot == slot.slot_index:
				emit_signal("active_weapon_updated")


func active_weapon_scroll_up():
	if active_weapon_slot == 0:
		active_weapon_slot = NUM_EQUIP_SLOTS - 1
	else:
		active_weapon_slot = active_weapon_slot - 1
	emit_signal("active_weapon_updated")

func active_weapon_scroll_down():
	active_weapon_slot = (active_weapon_slot + 1) % NUM_EQUIP_SLOTS
	emit_signal("active_weapon_updated")
