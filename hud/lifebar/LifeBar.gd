extends Control

signal dead

export var start_life = 12

var max_life = 12 setget set_max_life
var life = 12 setget set_life
var life_preview = 12 setget set_preview_life

const NBR_BY_HEART = 4.0
onready var hearts = $Hearts
onready var tween = $Tween


func _ready():
	self.max_life = 12
	self.life = start_life


func reset():
	self.life = max_life


func set_life(v):
	life = v
#	self.life_preview = life
	tween.stop_all()
	tween.interpolate_property(self,"life_preview",life_preview,life,abs(life_preview-life)/10,Tween.TRANS_LINEAR,Tween.EASE_IN)
	tween.start()
	if life <= 0:
		emit_signal("dead")


func set_preview_life(v):
	life_preview = v
	var remaining_life = life_preview
	for i in range(max_life/NBR_BY_HEART):
		hearts.get_child(i).frame = 0
	for i in range(ceil(life_preview/NBR_BY_HEART)):
		var child = hearts.get_child(i)
		var frame_target = clamp(remaining_life,0,4)
		remaining_life = clamp(remaining_life-4,0,INF)
		child.frame = frame_target


func set_max_life(v):
	max_life = v
	for child in hearts.get_children():
		child.visible = false
	for i in range(max_life/NBR_BY_HEART):
		hearts.get_child(i).visible = true
	self.life = clamp(life,0,max_life)
