extends Area2D
class_name Drops

var direction

func _ready() -> void:
	self.modulate.a = 0
	self.scale = Vector2.ZERO
	#TWEEN
	var tween = get_tree().create_tween()
	tween.set_parallel(true)

	tween.tween_property(self, "scale", Vector2(0.15, 0.15), 1).set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "modulate:a", 1.0, 0.25)
	
	connect("body_entered",drop_power)
	
func drop_power(_body: Node2D) -> void:
	pass
	
