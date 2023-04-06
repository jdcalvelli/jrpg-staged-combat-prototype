extends Node2D

# creating
# underscore for pseudo private
var _playerMech: PlayerMech
var _enemyMech: EnemyMech
var _playerText: RichTextLabel

var _attackButton: Button

enum States {START, PLAYER_TURN, PLAYER_CALC, ENEMY_TURN, ENEMY_CALC, END}
var _state: int

# Called when the node enters the scene tree for the first time.
# this is start
func _ready():
	
	_change_state(States.START)
	
	#Player Insantiation.
	# this is really not a good way to do this, should find a better one
	_playerText = get_node("PlayerStats") #This finds us the Text node so we can update it.
	# creates a new PlayerMech class and passes it's health and it's body parts. 
	_playerMech = PlayerMech.new(
		10, 
		{
			"leftArm": MechPart.new("Left Arm"),
			"rightArm": MechPart.new("Right Arm"),
			"leftLeg": MechPart.new("Left Leg"),
			"rightLeg": MechPart.new("Right Leg"),
		}
	)
	
	#Player Stats Display
	_playerText.text = ("Total Health is %s" % _playerMech.mechHealth) \
		+ ("\nLeft Arm Health: %s" % _playerMech.mechHealth) \
		+ ("\nRight Arm Health: %s" % _playerMech.mechHealth) \
		+ ("\nLeft Leg Health: %s" % _playerMech.mechHealth) \
		+ ("\nRight Leg Health: %s") % _playerMech.mechHealth
	
		
	#enemy Mech instantiation
	_enemyMech = EnemyMech.new(
		20,
		{
			"leftArm": MechPart.new("Enemy Left Arm"),
			"rightArm": MechPart.new("Enemy Right Arm"),
			"leftLeg": MechPart.new("Enemy Left Leg"),
			"rightLeg": MechPart.new("Enemy Right Leg"),
		}
	)
	
	#Player Button Instation
	_attackButton = get_node("CommandButton") #get_node works by finding nodes in the same node tree. so in this case the command button has to be childed to the GameManager for this to work as far as I've been able to work out. 
	
	_add_commands() #calls add command function. 
	
	_attackButton.connect("item_selected", _on_item_selected)
	
	#prints all the stats to make sure the parts are all being made properly
		#_print_test()


#Adds commands on start up for each limb on the player mech. 
func _add_commands():
	_attackButton.add_item("Select Part to Attack With") #adds the initial command that just says hey pick a command lol
	
	for _partKey in _playerMech.mechParts: #Populates the option menu with each part of the player mech. 
		_attackButton.add_item("Attack with "+ _playerMech.mechParts[_partKey].partName)
	#Considerations, When a part is destroyed is it possible to remove an item?
	#On the options button manual page there is a way to remove an item in the button based on it's index
	#Does godot index from 0 or 1?

# Called every frame. 'delta' is the elapsed time since the previous frame.
# this is update
# not being used right now
func _process(delta):
	
	
	pass

func _on_item_selected(id):
	
	if id == 1: 
		_playerMech.attack()
	if id == 2:
		pass
	if id == 3:
		pass
		
	

func _print_test():
	# just testing to make sure that instantiation worked right
	print("player elements")
	_playerMech.printHealth()
	_playerMech.printParts()
	_playerMech.attack()
	
	print("--------------")
	
	print("enemy elements")
	_enemyMech.printHealth()
	_enemyMech.printParts()
	_enemyMech.attack()
	
func _input(event):
	if Input.is_action_pressed("ui_accept"):
		_state +=1
		if _state > 5:
			_state = 0
		print(_state)
		_change_state(_state)
	pass
	
	#StateMachine
func _change_state(new_state: int):
	_state = new_state
	
	match _state:
		States.START:
			print("Start State")
			pass
		States.PLAYER_TURN:
			print("Start Player Turn")
			pass
		States.PLAYER_CALC:
			print("Calculating Player Combo/Damage")
			pass
		States.ENEMY_TURN:
			print("Start Enemy Turn")
			pass
		States.ENEMY_CALC:
			print("Calculating Enemy Damage")
			pass
		States.END:
			print("End of Combat")
			pass
	pass
