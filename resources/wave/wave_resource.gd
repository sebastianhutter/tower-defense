extends Resource
class_name WaveResource

# how long to wait before spawning the wave
@export var start_delay: float = 0.0

# sorted array of enemies to spawn
# the array is split in groups.
# each group will be randomly spawned from another spawner found in the 
# floor
@export var spawn_groups: Array[WaveGroupResource]