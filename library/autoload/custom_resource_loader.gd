extends Node
class_name CustomResourceLoader

var ability_resources: Array[AbilityResource]

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

func load_ability_resorces(path: String = "res://resources/ability") -> void:
	"""load all ability resources .tres files"""

	for ability_resource in find_tres_files(path):
		ability_resources.append(ability_resource as AbilityResource)

func get_ability_resource(ability_id: String) -> AbilityResource:
	"""returns the ability resource with the given id"""

	for ability_resource in ability_resources:
		if ability_resource.id == ability_id:
			return ability_resource
	
	return null

func _init() -> void:
	"""preload resources for faster access"""
	load_ability_resorces()
