extends Area2D
class_name Portal

@export var linked_portal : Portal

func _ready():
	GlobalEvents.portal_to.connect(send_my_coord)

func _on_body_entered(body):
	if body.name == "Player":
		GlobalEvents.portal_to.emit(linked_portal.name)

func send_my_coord(linked_portal):
	if self.name == linked_portal:
		GlobalEvents.send_portal_coord.emit(self.position)
