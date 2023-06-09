extends Node
class_name CustomResourceLoader

var tower_resources: Array[TowerResource]

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

func load_tower_resorces(path: String = Constants.TOWER_RESOURCE_FOLDER) -> void:
	""" load tower resources .tres files """

	for tower_resource in find_tres_files(path):
		tower_resources.append(tower_resource as TowerResource)

func get_tower_resources() -> Array[TowerResource]:
	"""returns all tower resources"""

	return tower_resources

func get_tower_resource(tower_id: String) -> TowerResource:
	"""returns the tower resource with the given id"""

	for tower_resource in tower_resources:
		if tower_resource.id == tower_id:
			return tower_resource

	return null

func _init() -> void:
	"""preload resources for faster access"""
	load_tower_resorces()
