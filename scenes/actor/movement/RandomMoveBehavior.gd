extends MoveBehavior


func _ready():
	self.disabled = true


func _on_Timer_timeout():
	if axis.length():
		self.axis = Vector2.ZERO
	else:
		var angle = deg2rad(rand_range(0,360))
		self.axis = Vector2(cos(angle), sin(angle))

func set_disabled(v):
	.set_disabled(v)
	$Timer.paused = disabled


func reset():
	self.disabled = false
	self.axis = Vector2.ZERO
