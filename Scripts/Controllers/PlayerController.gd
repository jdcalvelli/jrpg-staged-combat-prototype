class_name PlayerController

extends Node2D

var isGrabbing : bool
var isAOE : bool
var isCrit : bool

# variables for player mech
var PlayerMechModel: Mech = Mech.new(
			{
			"body": MechPart.new("body", 0, 100),
			"leftArm": MechPart.new("Left Arm", 5, 30),
			"rightArm": MechPart.new("Right Arm", 5, 30),
			"leftLeg": MechPart.new("Left Leg", 6, 30),
			"rightLeg": MechPart.new("Right Leg", 6, 30),
		})
# number of possible actions
var ActionPoints: int = 2
var target: MechPart
# sequence of actions
var AttackSequence: Array
var TotalDamage: Array

func SequencePartAttack(part: MechPart):
	# if you have the action points, add the attack to sequence
	if ActionPoints != 0:
		AttackSequence.append(part)
		TotalDamage.append(part.partDamage)
		print(AttackSequence.size())
		ActionPoints -= 1
	
func UnsequencePartAttack(part: MechPart):
	# if the part is in the sequence
	if AttackSequence.find(part) != -1:
		# remove part from attack sequence
		AttackSequence.pop_at(AttackSequence.find(part))
		# increase number of action points
		ActionPoints += 1
		
func CheckCombo():
	print("CHECKING COMBO =--")
	# this part should determine the combo
	# this is the ugliest thing ive ever written
	# i could figure out how to make it better but i wont rn
	# to make it better, each mechpart should have a limb type to reference instead of name
	if (AttackSequence[0].partName == "Left Arm"
	and AttackSequence[1].partName == "Right Arm"
	or AttackSequence[0].partName == "Right Arm"
	and AttackSequence[1].partName == "Left Arm"):
		print("arm combo")
		isGrabbing = true
		# stop the enemy from using that part for next turn
	elif (AttackSequence[0].partName == "Left Leg"
	and AttackSequence[1].partName == "Right Leg"
	or AttackSequence[0].partName == "Right Leg"
	and AttackSequence[1].partName == "Left Leg"):
		print("leg combo")
		isCrit = true
		# do double damage and maybe lose next turn
	elif (AttackSequence[0].partName == "Left Arm"
	and AttackSequence[1].partName == "Left Leg"
	or AttackSequence[0].partName == "Left Leg"
	and AttackSequence[1].partName == "Left Arm"
	or AttackSequence[0].partName == "Right Arm"
	and AttackSequence[1].partName == "Right Leg"
	or AttackSequence[0].partName == "Right Leg"
	and AttackSequence[1].partName == "Right Arm"
	or AttackSequence[0].partName == "Left Arm"
	and AttackSequence[1].partName == "Right Leg"
	or AttackSequence[0].partName == "Right Leg"
	and AttackSequence[1].partName == "Left Arm"
	or AttackSequence[0].partName == "Right Arm"
	and AttackSequence[1].partName == "Left Leg"
	or AttackSequence[0].partName == "Left Leg"
	and AttackSequence[1].partName == "Right Arm"):
		print("arm/leg combo")
		isAOE = true
		# spread the damage across parts (for the sake of it just random)
	
func ResolveAttackSequence(opponent: Mech, tempCombatLog: RichTextLabel, modifier):
	# this does the base damage for each thing
	for part in AttackSequence:
		PlayerMechModel.Attack(part, opponent, target, modifier)
		print("attack did %s damage with %s" % [part.partDamage, part.partName])

func ResolveAOEAttack(opponent: Mech, tempCombatLog: RichTextLabel):
	# resolve the attack sequence as it is, at half damage
	print(target)
	ResolveAttackSequence(opponent, tempCombatLog, 0.5)
	# pick a limb at random to set as target
	match randi() % 5:
		0:
			target = opponent.mechParts["leftArm"]
		1:
			target = opponent.mechParts["rightArm"]
		2:
			target = opponent.mechParts["leftLeg"]
		3:
			target = opponent.mechParts["rightLeg"]
		4:
			target = opponent.mechParts["body"]
	ResolveAttackSequence(opponent, tempCombatLog, 0.5)
	print(target)
	pass
