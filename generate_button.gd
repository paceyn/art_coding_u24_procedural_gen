extends Button


func _ready():
	print(get_tree().root.get_node("Main").get_node("Generator").generate())
	pressed.connect(_button_pressed.bind())


func _button_pressed():
	get_tree().root.get_node("Main").get_node("Generator").generate()
