class_name Droplet
extends Node2D

@export var color = Color.BLACK
@export var width = 2

@export var lifetime = 0.5
@export var length = 160
@export var theta_variance = 3
@export var min_move_speed = 150
@export var max_move_speed = 300
@export var turn_speed_variance = 3
@export var theta = 0

var line
var line_length
var line_pos

var move_speed
var turn_speed
var time_speed

var random


func _ready():
	random = RandomNumberGenerator.new()
	
	line = $Trail
	line.default_color = color
	line.width = width
		
	move_speed = (randi() % max_move_speed - min_move_speed) + min_move_speed
	turn_speed = random.randfn(0, turn_speed_variance) / PI
	time_speed = 1
	print(theta)
	theta += random.randfn(0, theta_variance) / PI
	print(theta)
	print("---")
	
	line.add_point(Vector2.ZERO)
	line_length = 1
	line_pos = Vector2.ZERO


func _process(delta):
	line_length = line.get_point_count()
	
	if time_speed > 0:
		line_pos += Vector2(delta * time_speed * move_speed * cos(theta), delta * move_speed * sin(theta))
		theta += delta * time_speed * turn_speed
		
		line.add_point(line_pos)
	
	if (time_speed <= 0 && line_length > 0) || line_length > 100:
		line.remove_point(0)
		
	time_speed -= (1.0 / lifetime) * delta
