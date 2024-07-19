extends Button

var variable_screen
var generator


func _ready():
	variable_screen = get_tree().root.get_node("Main").get_node("VariableScreen")
	variable_screen.visible = false
	
	generator = get_tree().root.get_node("Main").get_node("Generator")
	
	pressed.connect(_button_pressed.bind())


func _button_pressed():
	variable_screen.visible = !variable_screen.visible
	
	if !variable_screen.visible:
		generator.generate()
