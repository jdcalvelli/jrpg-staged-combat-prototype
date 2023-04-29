class_name EnemyController

extends Node2D

# variables for player mech
var EnemyMechModel: Mech = Mech.new(
			{
			"body": MechPart.new("body",0, 50),
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
		print(AttackSequence.size())
		ActionPoints -= 1
	
func ResolveAttackSequence(opponent: Mech, tempCombatLog: RichTextLabel):
	for part in AttackSequence:
		EnemyMechModel.Attack(part, opponent, target)
		
func DetermineRandomAttackSequence():
	for n in ActionPoints:
		match randi() % 4:
			0:
				if EnemyMechModel.mechParts["leftLeg"].partHealth <= 0:
					DetermineRandomAttackSequence()
				else:
					SequencePartAttack(EnemyMechModel.mechParts["leftLeg"])
			1:
				if EnemyMechModel.mechParts["rightLeg"].partHealth <= 0:
					DetermineRandomAttackSequence()
				else:
					SequencePartAttack(EnemyMechModel.mechParts["rightLeg"])
			2:
				if EnemyMechModel.mechParts["leftArm"].partHealth <= 0:
					DetermineRandomAttackSequence()
				else:
					SequencePartAttack(EnemyMechModel.mechParts["leftArm"])
			3:
				if EnemyMechModel.mechParts["rightArm"].partHealth <= 0:
					DetermineRandomAttackSequence()
				else:
					SequencePartAttack(EnemyMechModel.mechParts["rightArm"])

func DetermineRandomAttackTarget(player : Mech):
	
	if player.mechParts["body"].partHealth <= 0: 
		return;
	
	match randi() % 5:
		0:
			if player.mechParts["leftLeg"].partHealth > 0:
				target = player.mechParts["leftLeg"]
			else:
				DetermineRandomAttackTarget(player)
		1:
			if player.mechParts["rightLeg"].partHealth > 0:
				target = player.mechParts["rightLeg"]
			else:
				DetermineRandomAttackTarget(player)
		2:
			if player.mechParts["leftArm"].partHealth > 0:
				target = player.mechParts["leftArm"]
			else:
				DetermineRandomAttackTarget(player)
		3:
			if player.mechParts["rightArm"].partHealth > 0:
				target = player.mechParts["rightArm"]
			else:
				DetermineRandomAttackTarget(player)
		4:
			if player.mechParts["body"].partHealth > 0:
				target = player.mechParts["body"]
			else:
				DetermineRandomAttackTarget(player)
