extends Interactable

signal interacted(player : Player)

func interact(player : Player) -> void:
	print("Interacted.")
	interacted.emit(player)
