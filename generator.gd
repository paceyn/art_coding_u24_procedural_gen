extends Node2D

@export var circle_count = 8
@export var min_circle_points = 16
@export var max_circle_points = 32
@export var droplet_bloom = 2
@export var chaos = 3

var random

var inner_circle = "res://inner_circle.tscn"


# https://stackoverflow.com/revisions/71615282/1
func divide_integer(n, d):
	var result = []
	var rem = 0
	var current = 0
	for i in range(d):
		current += n / d
		rem += n % d
		if rem >= d:
			rem -= d
			current += 1
		result.append(current)
	return result


func generate():
	for i in get_children():
		i.queue_free()
	
	var circle_points = []
	for i in range(circle_count):
		circle_points.append(randi() % int(max_circle_points - min_circle_points) + int(min_circle_points))
	circle_points.sort()
	var circle_sizes = divide_integer(480, int(circle_count))
	
	for i in range(circle_count):
		var new_circle = load(inner_circle).instantiate()
		new_circle.radius = circle_sizes[i]
		new_circle.point_count = circle_points[i]
		
		if i == circle_count - 1:
			new_circle.fluctuation_max_height = (circle_sizes[i] - circle_sizes[i-1])
		else:
			new_circle.fluctuation_max_height = (circle_sizes[i+1] - circle_sizes[i])
		new_circle.fluctuation_min_height = new_circle.fluctuation_max_height / 2
		
		new_circle.fluctuation_particle_theta_variance = droplet_bloom
		new_circle.fluctuation_particle_turn_speed_variance = 3 * droplet_bloom
		new_circle.fluctuation_frequency = int(1000.0 / chaos)
		
		add_child(new_circle)


func _ready():
	random = RandomNumberGenerator.new()
	
	generate()
