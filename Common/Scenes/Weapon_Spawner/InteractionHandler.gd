extends Interactable

signal interacted(player : Player)

func interact(player : Player) -> void:
	interacted.emit(player)
