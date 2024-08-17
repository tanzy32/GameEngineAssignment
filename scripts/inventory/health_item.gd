class_name HeatlhItem extends InventoryItem

@export var health_increase: int = 1

func use(player: MyPlayer) -> void:
	player.increase_health(health_increase)





