extends Control

signal opened
signal closed

var isOpen: bool = false

@onready var inventory: Inventory = preload("res://scenes/levels/global/inventory/playerInventory.tres")
@onready var hotbar_slots: Array = $NinePatchRect/HBoxContainer.get_children()
@onready var slots: Array = hotbar_slots + $NinePatchRect/GridContainer.get_children()
@onready var ItemStackGuiClass = preload("res://scenes/levels/global/inventory/itemsStackGui.tscn")


var itemInHand: ItemStackGui
var oldIndex: int = -1
var locked: bool = false

func _ready():
	inventory.updated.connect(update)
	connectSlots()
	update()
	
func connectSlots():
	for i in range(slots.size()):
		var slot = slots[i]
		slot.index = i
		
		var callable = Callable(onSlotClicked)
		callable = callable.bind(slot)
		slot.pressed.connect(callable)
	
func update():
	for i in range(min(inventory.slots.size(),slots.size())):
		var inventorySlot: InventorySlot = inventory.slots[i]
	
		if !inventorySlot.item: 
			slots[i].clear()
			continue
		
		var itemStackGui: ItemStackGui = slots[i].itemStackGui
		if !itemStackGui:
			itemStackGui = ItemStackGuiClass.instantiate()
			slots[i].insert(itemStackGui)
			
		itemStackGui.inventorySlot = inventorySlot
		itemStackGui.update()
			
func open():
	visible = true
	isOpen = true
	opened.emit()
	
func close():
	visible = false
	isOpen = false
	closed.emit()

func takeItemFromSlot(slot):
	itemInHand = slot.takeItem()
	add_child(itemInHand)
	updateItemInHand()
	
	oldIndex = slot.index
	
func insertItemInSlot(slot):
	var item = itemInHand
	
	remove_child(itemInHand)
	itemInHand = null
	
	slot.insert(item)
	
	oldIndex = -1

func updateItemInHand():
	if !itemInHand: return
	itemInHand.global_position = get_global_mouse_position() - itemInHand.size/2

func onSlotClicked(slot):
	if locked: return
	if slot.isEmpty():
		if !itemInHand: return
		
		insertItemInSlot(slot)
		return
	
	if !itemInHand:
		takeItemFromSlot(slot)
		return
	
	if slot.itemStackGui.inventorySlot.item.name == itemInHand.inventorySlot.item.name:
		stackItems(slot)
		return
		
	swapItems(slot)

func swapItems(slot):
	var tempItem = slot.takeItem()
	
	insertItemInSlot(slot)
	
	itemInHand = tempItem
	add_child(itemInHand)
	updateItemInHand()
	
func stackItems(slot):
	var slotItem: ItemStackGui = slot.itemStackGui
	var maxAmount = slotItem.inventorySlot.item.maxAmountPerStack
	var totalAmount = slotItem.inventorySlot.amount + itemInHand.inventorySlot.amount
	
	if slotItem.inventorySlot.amount == maxAmount:
		swapItems(slot)
		return
	
	if totalAmount <= maxAmount:
		slotItem.inventorySlot.amount = totalAmount
		remove_child(itemInHand)
		itemInHand = null
		oldIndex = -1
	else:
		slotItem.inventorySlot.amount = maxAmount
		itemInHand.inventorySlot.amount = totalAmount - maxAmount
		
	slotItem.update()
	if itemInHand: itemInHand.update()
		
func putItemBack():
	locked = true
	if oldIndex < 0:
		var emptySlots = slots.filter(func (s): return s.isEmpty())
		if emptySlots.is_empty(): return
		
		oldIndex = emptySlots[0].index

	var targetSlot = slots[oldIndex]
	var tween = create_tween()
	var targetPosition = targetSlot.global_position + targetSlot.size / 2
	tween.tween_property(itemInHand, "global_position", targetPosition, 0.2)
	
	await tween.finished
	insertItemInSlot(targetSlot)
	locked = false

func _input(event):
	if itemInHand && !locked && Input.is_action_just_pressed("rightClick"):
		putItemBack()
	updateItemInHand()
	

	
	
	
	
	
	
	
	
