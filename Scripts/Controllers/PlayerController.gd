class_name PlayerController

extends Node2D

# variables for player mech
var PlayerMechModel: PlayerMech = PlayerMech.new(10,
			{
			"leftArm": MechPart.new("Left Arm", 5, 8),
			"rightArm": MechPart.new("Right Arm", 5, 8),
			"leftLeg": MechPart.new("Left Leg", 6, 4),
			"rightLeg": MechPart.new("Right Leg", 6, 4),
		})
# number of possible actions
var ActionPoints: int = 2
# sequence of actions
var AttackSequence: Array
var TotalDamage: Array

func SequencePartAttack(part: MechPart):
	# if you have the action points, add the attack to sequence
	if ActionPoints != 0:
		AttackSequence.append(part.partName)
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
	
func ResolveAttackSequence(sequence: Array):
	for part in AttackSequence:
		PlayerMechModel.Attack(part)
