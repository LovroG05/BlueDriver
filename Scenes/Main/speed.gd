extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var player = get_node("/root/Main/Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_LabelUpdateTimer_timeout():
	text = "%.2f" % player.get_speed_kph()
