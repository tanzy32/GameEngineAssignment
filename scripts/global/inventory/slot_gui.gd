extends Button

@onready var backgroundSprite: Sprite2D = $Background
@onready var container: CenterContainer = $CenterContainer
@onready var inventory = preload("res://scenes/levels/global/inventory/playerInventory.tres")

var itemStackGui: ItemStackGui
var index: int


func insert(isg: ItemStackGui):
	itemStackGui = isg
	backgroundSprite.frame = 1
	container.add_child(itemStackGui)
	
	if !itemStackGui.inventorySlot || inventory.slots[index] == itemStackGui.inventorySlot:
		return
		
	inventory.insertSlot(index, itemStackGui.inventorySlot)

func takeItem():
	var item = itemStackGui
	
	inventory.removeSlot(itemStackGui.inventorySlot)

	return item
	
	
func isEmpty():
	return !itemStackGui

func clear() -> void:
	if itemStackGui:
		container.remove_child(itemStackGui)
		itemStackGui = null
	backgroundSprite.frame = 0
