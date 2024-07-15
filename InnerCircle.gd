extends Node2D

@export var color = Color.BLACK
@export var width = 2
@export var radius = 100
@export var point_count = 90
@export var fluctuation_frequency = 1
@export var fluctuation_range = 10

var line
var radii
var radii_delta
var step_size


func pc_wrap(i):
	while i < 0:
		i += point_count
	while i > point_count - 1:
		i -= point_count
	
	return i


func apply_changes():
	step_size = (2 * PI) / point_count
	
	line.default_color = color
	line.width = width
	line.clear_points()
	
	radii = []
	radii_delta = []
	for i in range(point_count):
		var theta = step_size * i
		line.add_point(Vector2(radius * cos(theta) + position.x, radius * sin(theta) + position.y))
		radii.append(radius)
		radii_delta.append(0)


func _ready():
	line = $Line2D
	apply_changes()
	radii[0] = 120


func _process(delta):
	for i in range(point_count):
		radii[i] += delta * radii_delta[i]
		radii_delta[i] = (radius - radii[pc_wrap(i - 1)]) - (radius - radii[i])
		
		var theta = step_size * i
		line.set_point_position(i, Vector2(radii[i] * cos(theta) + position.x, radii[i] * sin(theta) + position.y))
