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

# as it turns out tres files are packed binary when exported:
# Note: If ProjectSettings.editor/export/convert_text_resources_to_binary is true, @GDScript.load will not be able to 
# read converted files in an exported project. If you rely on run-time loading of files present within the PCK, set 
# ProjectSettings.editor/export/convert_text_resources_to_binary to false.
# as this is the default behaviour I assume the idea of dynamically loading custom resources for using them
# in scripts need to be done a different way !
# a lesson for the next project... 
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

