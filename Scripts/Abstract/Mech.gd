# this is inheriting from Node2D (like monobehavior i think)
extends Node2D

# this is actually giving the class like a name that godot understands
# by default all scripts are classes, but need to be explicitly named
class_name Mech

# instance variables
# colon for static typing
var mechHealth: int

# mech parts object
# probably a more type-safe way to do this
var mechParts = {}

# constructor
func _init(_mechHealth: int, _mechParts: Dictionary):
	# setting instance mech heath at construction
	mechHealth = _mechHealth
	# setting instance mech parts at construction
	# at construction time, we need to make sure that we give a dict
	# with mech parts in it
	mechParts = _mechParts
	

# class methods
# just printing for now, test stuff
func printHealth():
	# string template example
	print("Health is %s" % mechHealth)

func printParts():
	# for key print out the name of the part in the value
	for _partKey in mechParts:
		print(mechParts[_partKey].partName)
		

# virtual methods that are overwritten by subclasses
func attack():
	pass
