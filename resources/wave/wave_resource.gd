extends Resource
class_name WaveResource

# how long to wait before spawning the wave
@export var start_delay: float = 0.0
# how long to wait to spawn the enemies in the wave
@export var spawn_delay: float = 0.3

# sorted array of enemies to spawn
# the array is split in groups.
# each group will be randomly spawned from another spawner found in the 
# floor
@export var spawn_groups: Array[WaveGroupResource]