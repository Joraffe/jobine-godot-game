extends Resource
class_name ImageData


var scene_name : String
var image_filename : String
var img_texture : ImageTexture


#------------------
# Constructor
#------------------
func _init(scene, filename):
	scene_name = scene
	image_filename = filename
	img_texture = load_img_texture()


#------------------
# Loading Texture
#------------------
func _img_dir():
	return "res://scenes/{scene}/resources/images".format({"scene": scene_name})

func _img_path_fmt():
	return "{dir}/{filename}".format({"dir": _img_dir()})

func _img_path():
	return _img_path_fmt().format({"filename": image_filename})


func load_img_texture():
	return ImageTexture.create_from_image(
		load(_img_path()).get_image()
	)


#-------------------
# Utility functions
#-------------------
func get_img_texture():
	return img_texture


func get_img_width():
	return img_texture.get_width()


func get_img_height():
	return img_texture.get_height()


func get_img_dimensions():
	return {
		"width": img_texture.get_width(),
		"height": img_texture.get_height()
	}
