extends Node

var item_id: int
var type: int
var proj_reload_dict := {}
var is_curr_menu_enabled: bool = false
@onready var extension_api: Node
@onready var export_api: Node

class ReloadData:
	var enabled: bool = false
	var modified_time: int = 0

# Runs as soon as extension is enabled. This script can act as a setup for the extension.
func _enter_tree() -> void:
	extension_api = get_node_or_null("/root/ExtensionsApi")
	export_api = get_node_or_null("/root/Export")
	type = extension_api.menu.FILE
	item_id = extension_api.menu.add_menu_item(type, "Hot Reload OFF for this Project", self)


func _exit_tree() -> void: # Extension is being uninstalled or disabled
	extension_api.menu.remove_menu_item(type, item_id)

func _process(_delta: float) -> void:
	# This function is called every frame
	var global = extension_api.general.get_global()
	var curr_project = extension_api.project.current_project
	for project in global.projects:
		if not proj_reload_dict.has(project):
			proj_reload_dict[project] = ReloadData.new()

		if project != curr_project:
			continue

		var file_path = get_file_path(project)

		if not is_valid_path(file_path):
			proj_reload_dict[project].enabled = false

		if proj_reload_dict[project].enabled:
			var modified_time = FileAccess.get_modified_time(file_path)
			if proj_reload_dict[project].modified_time != modified_time:
				proj_reload_dict[project].modified_time = modified_time
				reload_project(project)
	
	for project in proj_reload_dict.keys():
		if project not in global.projects:
			proj_reload_dict.erase(project)
	
	var enabled = proj_reload_dict[curr_project].enabled
	update_menu_item_text(enabled)

func update_menu_item_text(enabled: bool) -> void:
	if enabled == is_curr_menu_enabled:
		return
	is_curr_menu_enabled = enabled
	var global = extension_api.general.get_global()
	var text = "ON" if enabled else "OFF"
	global.top_menu_container.file_menu.set_item_text(item_id, "Hot Reload " + text + " for this Project")
	

func is_valid_path(file_path: String) -> bool:
	return FileAccess.file_exists(file_path)

func get_file_path(project):
	var file_path = project.export_directory_path + "/" + project.file_name + export_api.file_format_string(project.file_format)
	return file_path

func reload_project(project):
	var global = extension_api.general.get_global()
	var size = global.current_project.size
	var file_path = get_file_path(project)
	var image := Image.load_from_file(file_path)
	if image.get_width() != size.x or image.get_height() != size.y:
		extension_api.general.get_drawing_algos().resize_canvas(image.get_width(), image.get_height(), 0, 0)
	extension_api.project.set_pixelcel_image(image, project.current_frame, project.current_layer)
	
func menu_item_clicked():
	# Do some stuff
	var project = extension_api.project.current_project
	if not is_valid_path(get_file_path(project)):
		proj_reload_dict[project] = [false, 0]
		return
	if proj_reload_dict.has(project):
		proj_reload_dict[project].enabled = not proj_reload_dict[project].enabled
	else:
		proj_reload_dict[project] = ReloadData.new()
		proj_reload_dict[project].enabled = !is_curr_menu_enabled
