extends Node
class_name MoveBehavior

signal axis_changed(axis)
var axis = Vector2.ZERO setget set_axis
var disabled = false setget set_disabled


func set_axis(v):
	if disabled:
		return
	axis = v
	emit_signal("axis_changed",v)


func set_disabled(v):
	if disabled:
		self.axis = Vector2.ZERO
	disabled = v
