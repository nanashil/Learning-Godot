extends Control

var hearts = 4 setget set_hearts
var maxhearts = 4 setget set_maxhearts

onready var UILifeFull = $LifeUIFull
onready var UILifeEmpty = $LifeUIEmpty


func set_hearts(value):
	hearts = clamp(value, 0, maxhearts)
	if UILifeFull != null:
		UILifeFull.rect_size.x = hearts * 15
	

func set_maxhearts(value):
	maxhearts = max(value, maxhearts)
	self.hearts = min(hearts, maxhearts)
	if UILifeEmpty != null:
		UILifeEmpty.rect_size.x = maxhearts * 15

#		I changed the maxhearts = max to be equal to maxhearts on the tutorial the guy used 1 but it just... doesnt work?
#		I dunno why it doesnt work here with the value set to 1, to be honest setting it to 1 doesnt make any sense, so I changed it to be functional, if it brakes the code it breaks, nothing I can do

func _ready():
	self.maxhearts = PlayerStats.max_HP
	self.hearts = PlayerStats.health
# warning-ignore:return_value_discarded
	PlayerStats.connect("health_changed", self, "set_hearts")
# warning-ignore:return_value_discarded
	PlayerStats.connect("health_changed", self, "set_maxhearts")
