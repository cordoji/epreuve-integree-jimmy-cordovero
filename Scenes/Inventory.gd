extends Node2D

const SlotClass = preload("res://Scripts/Slot.gd")
onready var inventory_slots = $GridContainer
var holding_weapon = null

func _ready():
	for inv_slot in inventory_slots.get_children():
		inv_slot.connect("gui_input", self, "slot_gui_input", [inv_slot])

func slot_gui_input(event: InputEvent, slot: SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			if holding_weapon != null:
				if !slot.weapon:
					slot.putIntoSlot(holding_weapon)
					holding_weapon = null
				else:
					var temp_weapon = slot.weapon
					slot.pickFromSlot()
					temp_weapon.global_position = event.global_position
					slot.putIntoSlot(holding_weapon)
					holding_weapon = temp_weapon
			elif slot.weapon:
				holding_weapon = slot.weapon
				slot.pickFromSlot()
				holding_weapon.global_position = get_global_mouse_position()

func _input(event):
	if holding_weapon:
		holding_weapon.global_position = get_global_mouse_position()
