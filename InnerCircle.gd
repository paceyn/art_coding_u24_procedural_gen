extends Node2D

@export var color = Color.BLACK
@export var width = 2

@export var radius = 100
@export var max_radius = 120

@export var point_count = 16

@export var grow_speed_1 = 20
@export var grow_speed_2 = 5
@export var shrink_speed = 50
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
	radii[0] = 130


func _process(delta):
	for i in range(point_count):
		radii[i] += delta * radii_delta[i]
		
		if radii[i] > max_radius:
			radii_delta[i] -= shrink_speed * delta
			radii_delta[pc_wrap(i + 1)] += grow_speed_1 * delta
			radii_delta[pc_wrap(i + 2)] += grow_speed_2 * delta
		if radii[i] < radius:
			radii[i] = radius
			radii_delta[i] = 0
		
		var theta = step_size * i
		line.set_point_position(i, Vector2(radii[i] * cos(theta) + position.x, radii[i] * sin(theta) + position.y))
