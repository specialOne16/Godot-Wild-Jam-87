extends StaticBody2D
class_name Tree_

func damaged():
	ResourceManager.gain_wood()
	queue_free()
