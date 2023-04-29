class_name PlayerController

extends Node2D

var isGrabbing : bool
var isAOE : bool
var isCrit : bool

# variables for player mech
var PlayerMechModel: Mech = Mech.new(
			{
			"body": MechPart.new("body", 0, 50),
			"leftArm": MechPart.new("Left Arm", 5, 8),
			"rightArm": MechPart.new("Right Arm", 5, 8),
			"leftLeg": MechPart.new("Left Leg", 6, 4),
			"rightLeg": MechPart.new("Right Leg", 6, 4),
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
	
func ResolveAttackSequence(opponent: Mech, tempCombatLog: RichTextLabel):
	# this does the base damage for each thing
	for part in AttackSequence:
		PlayerMechModel.Attack(part, opponent, target)
		print("attack did %s damage with %s" % [part.partDamage, part.partName])
	# this part should determine the combo
	# this is the ugliest thing ive ever written
	# i could figure out how to make it better but i wont rn
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
