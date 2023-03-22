extends Mech

class_name EnemyMech

# creating subclass for enemy mech
# because behaviors will be different

# constructor with pass up to parent class
func _init(_mechHealth: int, _mechParts: Dictionary):
	super._init(_mechHealth, _mechParts)

# virtual overrides
func attack():
	print("enemy attacks")
