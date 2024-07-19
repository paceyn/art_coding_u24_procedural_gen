class_name InnerCircle
extends Node2D

@export var color = Color.BLACK
@export var width = 2

@export var radius = 100

@export var point_count = 16

@export var fluctuation_frequency = 200
@export var fluctuation_min_height = 40
@export var fluctuation_max_height = 80
@export var fluctuation_time_elapsed = 1
@export var fluctuation_particle_count_min = 3
@export var fluctuation_particle_count_max = 6

@export var fluctuation_particle_turn_speed_variance = 5
@export var fluctuation_particle_theta_variance = 1

var line
var radii
var radii_delta
var step_size
var fluctuating
var fluctuation_time
var fluctuation_current_height
var fluctuation_particles_emitted

var fluctuation_particle


func double_ease_in_out_sine(x):
	if x > 0.5:
		return -(cos(2 * PI * x) - 1) / 2
	else:
		return -(cos(2 * PI * x) - 1) / 2


func _ready():
	randomize()
	fluctuation_particle = "res://droplet.tscn"
	step_size = (2 * PI) / point_count
	
	line = $InnerCircleLine
	line.default_color = color
	line.width = width
	
	radii = []
	radii_delta = []
	for i in range(point_count):
		var theta = step_size * i
		line.add_point(Vector2(radius * cos(theta) + position.x, radius * sin(theta) + position.y))
		radii.append(radius)
		radii_delta.append(0)
		
	fluctuating = -1


func _process(delta):
	if (randi() % fluctuation_frequency) <= 1 && fluctuating == -1:
		fluctuating = (randi() % point_count)
		fluctuation_time = 0
		fluctuation_current_height = pow(-1, (randi() % 2)) * ((randi() % (fluctuation_max_height - fluctuation_min_height)) + fluctuation_min_height)
		fluctuation_particles_emitted = false
	
	for i in range(point_count):
		var theta = step_size * i
		
		if fluctuating == i:
			radii[i] = radius + (fluctuation_current_height * double_ease_in_out_sine(fluctuation_time))
			fluctuation_time += (1.0 / fluctuation_time_elapsed) * delta
			
			if fluctuation_time > 0.5 && !fluctuation_particles_emitted:
				for j in range(fluctuation_particle_count_min + (randi() % (fluctuation_particle_count_max - fluctuation_particle_count_min))):
					var new_particle = load(fluctuation_particle).instantiate()
					new_particle.position = Vector2(radii[i] * cos(theta) + position.x, radii[i] * sin(theta) + position.y)
					new_particle.theta = theta
					new_particle.theta_variance = fluctuation_particle_theta_variance
					new_particle.turn_speed_variance = fluctuation_particle_turn_speed_variance
					new_particle.color = color
					if radii[i] < radius:
						new_particle.theta *= -1
					add_child(new_particle)
				fluctuation_particles_emitted = true
				
			if fluctuation_time > 1:
				fluctuating = -1
				radii[i] = radius
		
		line.set_point_position(i, Vector2(radii[i] * cos(theta) + position.x, radii[i] * sin(theta) + position.y))
	
	for i in get_children():
		if i == line:
			continue
		if i.line_length == 0:
			i.queue_free()
