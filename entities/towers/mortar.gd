extends Area2D

var mortar_shell : PackedScene = preload("uid://da686fr5xaikc")  

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect_signals()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func connect_signals() ->  void:
	self.body_entered.connect(shoot_mortar)

func shoot_mortar(_body: Node2D) -> void:
	print_debug('hit')
