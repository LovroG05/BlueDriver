extends Position3D


var player

func _ready():
	player = get_node("/root/Main/Player")
	
func _process(_delta):
	translation.z = player.translation.z
	translation.x = player.translation.x + 15
	pass
