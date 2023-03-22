extends Node2D

# creating
# underscore for pseudo private
var _playerMech: PlayerMech
var _enemyMech: EnemyMech

# Called when the node enters the scene tree for the first time.
# this is start
func _ready():
	# this is really not a good way to do this, should find a better one
	_playerMech = PlayerMech.new(
		10, 
		{
			"leftArm": MechPart.new("Left Arm"),
			"rightArm": MechPart.new("Right Arm"),
			"leftLeg": MechPart.new("Left Leg"),
			"rightLeg": MechPart.new("Right Leg"),
		}
	)
		
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
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
# this is update
# not being used right now
func _process(delta):
	pass
