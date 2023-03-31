extends Node2D

# creating
# underscore for pseudo private
var _playerMech: PlayerMech
var _enemyMech: EnemyMech
var _playerText: RichTextLabel

var attackButton: Button

#State Machine, TBD
#enum States {Round_Start, Player_Select, Player_Target, Enemy_Select, Enemy_Target, Damage_Calc}

# Called when the node enters the scene tree for the first time.
# this is start
func _ready():
	
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
	
	_playerText.text = ("Total Health is %s" % _playerMech.mechHealth) \
	+ ("\nLeft Arm Health: %s" % _playerMech.mechHealth) \
	+ ("\nRight Arm Health: %s" % _playerMech.mechHealth) \
	+ ("\nLeft Leg Health: %s" % _playerMech.mechHealth) \
	+ ("\nRight Leg Health: %s") % _playerMech.mechHealth
	
	#Player Button Instation
	attackButton = get_node("CommandButton") #get_node works by finding nodes in the same node tree. so in this case the command button has to be childed to the GameManager for this to work as far as I've been able to work out. 
	_add_commands() #calls add command function. 
		
	_enemyMech = EnemyMech.new(
		20,
		{
			"leftArm": MechPart.new("Enemy Left Arm"),
			"rightArm": MechPart.new("Enemy Right Arm"),
			"leftLeg": MechPart.new("Enemy Left Leg"),
			"rightLeg": MechPart.new("Enemy Right Leg"),
		}
	)
	
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
	

#Adds commands on start up for each limb on the player mech. 
func _add_commands():
	attackButton.add_item("Select Part to Attack With") #adds the initial command that just says hey pick a command lol
	
	for _partKey in _playerMech.mechParts: #Populates the option menu with each part of the player mech. 
		attackButton.add_item(_playerMech.mechParts[_partKey].partName)
	#Considerations, When a part is destroyed is it possible to remove an item?
	#On the options button manual page there is a way to remove an item in the button based on it's index
	#Does godot index from 0 or 1?

# Called every frame. 'delta' is the elapsed time since the previous frame.
# this is update
# not being used right now
func _process(delta):
	pass
