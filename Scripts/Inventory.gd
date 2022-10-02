extends Node2D

var url = "https://contralands.azurewebsites.net/"
var headers = ["Content-Type: application/json"]

const SlotClass = preload("res://Scripts/Slot.gd")
var weapon_scene = preload("res://Scenes/Weapon.tscn")

onready var inventory_slots = $GridContainer
onready var equip_slots = $EquipSlots.get_children()
var holding_weapon = null

var inv_init = false
var equip_init = false

var location_origin
var location_destination

func _ready():
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")
#
#	var data_to_send = { "owner_username" : get_tree().root.get_node("Master").username }
#	_make_post_request(url, "inventory", data_to_send, true)
	
	var inv_slots = inventory_slots.get_children()
	for i in range (inv_slots.size()):
		inv_slots[i].connect("gui_input", self, "slot_gui_input", [inv_slots[i]])
		inv_slots[i].slot_index = i
		inv_slots[i].slotType = SlotClass.SlotType.INVENTORY
		
	for i in range(equip_slots.size()):
		PlayerInventory.connect("active_weapon_updated", equip_slots[i], "refresh_style")
		equip_slots[i].connect("gui_input", self, "slot_gui_input", [equip_slots[i]])
		equip_slots[i].slot_index = i
		equip_slots[i].slotType = SlotClass.SlotType.EQUIPMENT
		
#	initialize_inventory()
#	initialize_equips()

func _make_post_request(url, method, data_to_send, use_ssl):
	
	var query = JSON.print(data_to_send)
	print(query)
	$HTTPRequest.request(url + method, headers, use_ssl, HTTPClient.METHOD_POST, query)

func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	print(json.result)

func slot_gui_input(event: InputEvent, slot: SlotClass):
	var data_to_send
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			if holding_weapon != null:
				if !slot.weapon:
					location_destination = get_location(slot)
					data_to_send = {"id" : holding_weapon.weaponid, "location": location_destination, "index" : slot.slot_index}
					slot.putIntoSlot(holding_weapon)
					PlayerInventory.add_weapon_to_empty_slot(holding_weapon, slot)
					holding_weapon = null
					_make_post_request(url, "updateweapon", data_to_send, true)
				else:
					location_destination = get_location(slot)
					data_to_send = {"id_origin" : holding_weapon.weaponid, 
									"location_origin": location_origin, 
									"index_origin" : holding_weapon.index, 
									"id_destination" : slot.weapon.weaponid, 
									"location_destination": location_destination, 
									"index_destination" : slot.slot_index}
					var temp_weapon = slot.weapon
					slot.pickFromSlot()
					PlayerInventory.remove_weapon(slot)
					temp_weapon.global_position = event.global_position
					slot.putIntoSlot(holding_weapon)
					PlayerInventory.add_weapon_to_empty_slot(holding_weapon, slot)
					holding_weapon = temp_weapon
					_make_post_request(url, "switchweapon", data_to_send, true)
					location_origin = get_location(slot)
			elif slot.weapon:
				location_origin = get_location(slot)
				holding_weapon = slot.weapon
				holding_weapon.index = slot.slot_index
				slot.pickFromSlot()
				PlayerInventory.remove_weapon(slot)
				holding_weapon.global_position = get_global_mouse_position()

func get_location(slot):
	match slot.slotType:
		SlotClass.SlotType.INVENTORY:
			return "inventory"
		SlotClass.SlotType.EQUIPMENT:
			return "equipment"

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
#	for i in range(PlayerInventory.inventory.size()):
#		print(PlayerInventory.inventory[i][0].position)

func reset_inventory():
	var slots = inventory_slots.get_children()
	for i in range(slots.size()):
		delete_children(slots[i])
		slots[i].weapon = null
		slots[i].refresh_style()

static func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
