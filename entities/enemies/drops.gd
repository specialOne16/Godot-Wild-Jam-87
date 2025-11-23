extends Area2D
class_name Drops

var direction
var drop = ResourceManager.player_upgrade[randi() % ResourceManager.player_upgrade.size()]

func _ready() -> void:
	if drop == 'wood':
		self.modulate = '#c33502'
	if drop == 'steel':
		self.modulate = '#fed9e4'
	if drop == 'stone':
		self.modulate = '#b99e27'
	if drop == 'hp':
		self.modulate = '#00e1d0'
	if drop == 'damage':
		self.modulate = '#ef0012'
		
	self.modulate.a = 0
	self.scale = Vector2.ZERO
	#TWEEN
	var tween = get_tree().create_tween()
	tween.set_parallel(true)

	tween.tween_property(self, "scale", Vector2(.5, .5), 1).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "modulate:a", 1.0, 0.25)
	
	connect("body_entered",orb_pickup)
	
func orb_pickup(body: Node2D) -> void:
	if not body is Player: return
	
	var orb_pickup_tween = get_tree().create_tween()
	orb_pickup_tween.set_parallel(true)
	orb_pickup_tween.tween_property(self, "scale", Vector2(0, 0), .5)
	orb_pickup_tween.tween_property(self, "modulate:a", 0.0, .5).from(1.0)
	orb_pickup_tween.tween_property(self, "global_position",body.global_position,.5)
	
	await orb_pickup_tween.finished
	
	if drop == 'wood':
		ResourceManager.current_wood += 10
	elif drop == 'steel':
		ResourceManager.current_steel += 10
	elif drop == 'stone':
		ResourceManager.current_stone += 10
	elif drop == 'hp':
		body.current_health += 10
	elif drop == 'damage':
		body.bullet_damage += 10
	
	queue_free()
