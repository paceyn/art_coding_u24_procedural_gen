extends Node2D

@export var color = Color.WHITE
@export var width = 5
@export var radius = 100
@export var point_count = 360
@export var fluctuation_frequency = 1
@export var fluctuation_range = 10

var line


func apply_changes():
	line.default_color = color
	line.width = width
	line.clear_points()
	
	var step_size = (2 * PI) / point_count
	for i in range(point_count):
		var theta = step_size * i
		line.add_point(Vector2(radius * cos(theta) + position.x, radius * sin(theta) + position.y))


func _ready():
	line = $Line2D
	apply_changes()


func _process(delta):
	pass
