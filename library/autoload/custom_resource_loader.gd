extends Node
class_name CustomResourceLoader

var tower_resources: Array[TowerResource]
var floor_resources: Array[FloorResource]

func _sort_by_int_id(a: Resource, b: Resource) -> bool:
	"""sorts resources by their id"""

	var a_id = a.get("id")
	var b_id = b.get("id")

	if a_id < b_id:
		return true
	
	return false

func find_tres_files(folder: String) -> Array[Resource]:
	"""returns a list of .tres files in one folder and one level of subfolders"""

	var dir = DirAccess.open(folder)
	var tres_files: Array[Resource] = []

	if dir:
		for subdir in dir.get_directories():
			var sub_dir = DirAccess.open(folder + "/" + subdir)
			if sub_dir:
				for file in sub_dir.get_files():
					if file.ends_with(".tres"):
						var resource = ResourceLoader.load(folder + "/" + subdir + "/" + file)
						tres_files.append(resource)
		
		for file in dir.get_files():
			if file.ends_with(".tres"):
				var resource = ResourceLoader.load(folder + "/" + file)
				tres_files.append(resource)
		
	return tres_files

func load_tower_resources(path: String = Constants.TOWER_RESOURCE_FOLDER) -> void:
	""" load tower resources .tres files """

	for tower_resource in find_tres_files(path):
		tower_resources.append(tower_resource as TowerResource)

func get_tower_resources() -> Array[TowerResource]:
	"""returns all tower resources"""

	return tower_resources

func load_floor_resources(path: String = Constants.FLOOR_RESOURCE_FOLDER) -> void:
	""" load floor resources .tres files """

	for floor_resource in find_tres_files(path):
		floor_resources.append(floor_resource as FloorResource)

	floor_resources.sort_custom(_sort_by_int_id)

func get_floor_resources() -> Array[FloorResource]:
	"""returns all tower resources"""

	return floor_resources

func _init() -> void:
	"""preload resources for faster access"""
	load_tower_resources()
	load_floor_resources()

