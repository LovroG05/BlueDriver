extends Label


var score = 0
onready var player = get_node("/root/Main/Player")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TickTimer_timeout():
	if player.drifting:
		score += 1
		text = "Score: %s" % score
