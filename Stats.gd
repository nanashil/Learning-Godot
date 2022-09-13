extends Node

export(int) var max_HP = 1 setget set_max_HP
var health = max_HP setget set_health

signal no_healt
signal health_changed(value)
signal max_health_changed(value)

func set_max_HP(value):
	max_HP = value
	self.health = min(health, max_HP)
	emit_signal("max_health_changed", max_HP)

func set_health(value):
	health = value
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_healt")

func _ready():
	self.health = max_HP
