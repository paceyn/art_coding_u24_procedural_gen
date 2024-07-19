extends ColorRect

var circle_count
var min_circle_points
var max_circle_points
var droplet_bloom
var chaos

var generator


func _ready():
	circle_count = $CircleCount
	min_circle_points = $MinCirclePoints
	max_circle_points = $MaxCirclePoints
	droplet_bloom = $DropletBloom
	chaos = $Chaos
	
	generator = get_tree().root.get_node("Main").get_node("Generator")


func _process(delta):
	generator.circle_count = circle_count.value
	generator.min_circle_points = min_circle_points.value
	generator.max_circle_points = max_circle_points.value
	generator.droplet_bloom = droplet_bloom.value
	generator.chaos = chaos.value
