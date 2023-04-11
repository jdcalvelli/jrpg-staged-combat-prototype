extends Node2D

# creating
# underscore for pseudo private
var _player: PlayerController #reference to the actual player controller
var _playerMech: Mech #reference to the player mech class 
var _enemy: EnemyController
var _enemyMech: Mech #reference to the enemy mech class
var _playerText: RichTextLabel #reference to the text for player stats
var _attackQueueText: RichTextLabel #reference to attack queue text. 
var _enemyText: RichTextLabel

var _attackButton: Button

enum States {START, PLAYER_TURN, PLAYER_CALC, ENEMY_TURN, ENEMY_CALC, END}
var _state: int

var _playerDamage: int 
# Called when the node enters the scene tree for the first time.
# this is start
func _ready():
	
	#variable instatiation
	_player = get_node("../PlayerController")
	_playerMech = _player.PlayerMechModel
	_enemy = get_node("../EnemyController")
	_enemyMech = _enemy.EnemyMechModel
	
	_attackQueueText = get_node("../AttackQueue")
	
	_player.AttackSequence.clear()
	_change_state(States.START)
	
	
	
	#Player Insantiation.
	# this is really not a good way to do this, should find a better one
	_playerText = get_node("PlayerStats") #This finds us the Text node so we can update it.
	_enemyText = get_node("EnemyStats")
	
	#Player Stats Display
	_playerText.text = ("Total Health is %s" % _playerMech.mechHealth) \
		+ ("\nLeft Arm Health: %s" % _playerMech.mechParts["leftArm"].partHealth) \
		+ ("\nRight Arm Health: %s" % _playerMech.mechParts["rightArm"].partHealth) \
		+ ("\nLeft Leg Health: %s" % _playerMech.mechParts["leftLeg"].partHealth) \
		+ ("\nRight Leg Health: %s") % _playerMech.mechParts["rightLeg"].partHealth
		
	_enemyText.text = ("Total Health is %s" % _enemyMech.mechHealth) \
		+ ("\nLeft Arm Health: %s" % _enemyMech.mechParts["leftArm"].partHealth) \
		+ ("\nRight Arm Health: %s" % _enemyMech.mechParts["rightArm"].partHealth) \
		+ ("\nLeft Leg Health: %s" % _enemyMech.mechParts["leftLeg"].partHealth) \
		+ ("\nRight Leg Health: %s") % _enemyMech.mechParts["rightLeg"].partHealth
	
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

func _process(delta):
	#_transition_to_player_calc()
	pass

func _transition_to_player_calc():
	if _state != States.PLAYER_TURN: return
	if _player.ActionPoints > 0: return
	_state +=1
	_change_state(_state)
	pass

func _on_item_selected(id):
	
	if id == 1: 
		_playerMech.attack()
	if id == 2:
		pass
	if id == 3:
		pass
		
	
func _input(event):
#	if Input.is_action_pressed("ui_accept"):
#		_state +=1
#		if _state > 5:
#			_state = 0
#		print(_state)
#		_change_state(_state)
	pass
	
	#StateMachine
func _change_state(new_state: int):
	_state = new_state
	
	match _state:
		States.START:
			_player.ActionPoints = 2 #sets player action points.
			_player.AttackSequence.clear()
			_player.TotalDamage.clear()
			print("Start State")
			_state += 1
			_change_state(_state)
			pass
		States.PLAYER_TURN:
			print("Start Player Turn")
			pass
		States.PLAYER_CALC:
			print("Calculating Player Combo/Damage")
			_playerDamage = _player.TotalDamage[0] + _player.TotalDamage[1] #takes both values in damage array and adds them togehter.
			print("player deals %s " % _playerDamage + ("damage. Combo TBD"))
			_change_state(States.ENEMY_TURN)
			pass
		States.ENEMY_TURN:
			print("Start Enemy Turn")
			_enemy.DetermineRandomAttackSequence()
			_change_state(States.ENEMY_CALC)
			pass
		States.ENEMY_CALC:
			print("Calculating Enemy Damage")
			_enemy.ResolveAttackSequence()
			_change_state(States.END)
			pass
		States.END:
			print("End of Combat")
			pass
	pass

#button Presses
func _on_left_arm_button_button_down():
	#unless state is PLAYER_TURN;
	if _state != States.PLAYER_TURN: return
	_prep_attack_for_queue("Left Arm",_playerMech.mechParts["leftArm"])#adds attack to que based on the part defined.

func _on_right_arm_button_button_down():
	if _state != States.PLAYER_TURN: return
	_prep_attack_for_queue("Right Arm", _playerMech.mechParts["rightArm"])

func _on_left_leg_button_button_down():
	if _state != States.PLAYER_TURN: return
	_prep_attack_for_queue("Left Leg",_playerMech.mechParts["leftLeg"])

func _on_right_leg_button_button_down():
	if _state != States.PLAYER_TURN: return
	_prep_attack_for_queue("Right Leg",_playerMech.mechParts["rightLeg"])
	
func _on_clear_button_button_down():
	if _state != States.PLAYER_TURN: return
	_player.AttackSequence.clear()
	_player.TotalDamage.clear()
	_player.ActionPoints = 2
	_update_queue()

#when pressing confirm button
func _on_confirm_attack_button_down(): 
	if _state != States.PLAYER_TURN: return
	if _player.ActionPoints > 0: return #These checks just make sure that if the state is not player turn and action points are greater than zero we don't do anything on press. 
	_state += 1 #ups the state count
	_change_state(_state) #changes state to player calc state.


func _prep_attack_for_queue(_partname: String, _part: MechPart):
	_player.SequencePartAttack(_part)
	_update_queue()
	
func _update_queue():
#	print("test")
	if _player.AttackSequence.size() <= 0: #if there are no attacks in the queue;
		_attackQueueText.text = "No Attacks Queued"
	if _player.AttackSequence.size() > 0 && _player.AttackSequence.size() < 2:
		_attackQueueText.text = ("%s " % _player.AttackSequence[0]) + ("is queued")
		print(_player.AttackSequence[0])
	if _player.AttackSequence.size() == 2:
		_attackQueueText.text = ("%s " % _player.AttackSequence[0]) + ("and ") + ("%s " % _player.AttackSequence[1]) + ("are queued.")
		print(_player.AttackSequence[1])





