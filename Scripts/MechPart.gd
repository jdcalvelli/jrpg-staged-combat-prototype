extends Node2D

class_name MechPart

# instance variables
var partName: String
var partDamage: int
var partHealth: int

# constructor
func _init(_partName: String, _partDamage: int, _partHealth: int):
	partName = _partName
	partDamage = _partDamage
	partHealth = _partHealth
