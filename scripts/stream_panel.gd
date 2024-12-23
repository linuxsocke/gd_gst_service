extends Panel

#| BEGIN | vars |
###########################################################################################
@onready var stream_texture_rect: TextureRect = get_node("CenterContainer/StreamTextureRect")
@onready var starting_texture_rect: TextureRect = get_node("CenterContainer/StreamTextureRect/StartingTextureRect")
@onready var stream_button: Button = get_node("CenterContainer/StreamButton")

@export var ip_address: String
@export var stream_port: String
@export var background_texture: Texture2D

var _gd_gst_service: GDGstService = GDGstService.new()
var _starting_pipeline: bool = false
###########################################################################################
#| END   | vars |

#| BEGIN | generic overrides |
###########################################################################################
# @override
func _ready()->void:
	stream_button.button_up.connect(_on_stream_button_up)
	self.tree_exited.connect(_on_tree_exited)
	background_texture = stream_texture_rect.texture
	#_gd_gst_service = GDGstService.new()
	if _gd_gst_service.initialize() != GDGstService.GD_SUCCESS:
		printerr("GDGstService init failed.")
		return
	print("GDGstService initialized")
	_reset()

# @override
func _process(_delta: float)->void:
	if not _gd_gst_service or not _gd_gst_service.is_running(): return
	stream_texture_rect.texture = _gd_gst_service.get_texture_sample()
	if _starting_pipeline:
		_starting_pipeline = false
		set_physics_process(false)
		starting_texture_rect.hide()
		stream_texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

func _physics_process(delta: float)->void:
	starting_texture_rect.rotation += delta * 5.
###########################################################################################
#| END   | generic overrides |

#| BEGIN | private |
###########################################################################################
func _reset()->void:
	if _gd_gst_service:
		_gd_gst_service.stop_pipeline()
	stream_texture_rect.texture = background_texture
	stream_texture_rect.stretch_mode = TextureRect.STRETCH_SCALE
	stream_button.modulate = Color(1, 1, 1, 1)
	starting_texture_rect.hide()
	_starting_pipeline = false
	set_process(false)
	set_physics_process(false)
	print("GDGstService Pipeline stopped.")
###########################################################################################
#| END   | private |

#| BEGIN | public |
###########################################################################################
func setup(ip: String, port: String)->bool:
	ip_address = ip
	stream_port=port
	return true

func reset()->void:
	_reset()
###########################################################################################
#| END   | public |

#| BEGIN | Signal callbacks |
###########################################################################################
func _on_stream_button_up()->void:
	if not _gd_gst_service: return
	if not _starting_pipeline and not _gd_gst_service.is_running():
		var stream_uri: String = "srt://%s:%s" % [ip_address, stream_port]
		print("GGGstService Starting pipeline with stream url %s ..  " % stream_uri)
		if ip_address.is_empty() or stream_port.is_empty(): 
			printerr("GDGstService start pipeline failed. Uri %s not valid." % stream_uri)
			return
		# TODO emit signal that pipeline will be started
		if _gd_gst_service.start_pipeline(stream_uri) != GDGstService.GD_SUCCESS:
			printerr("GDGstService start pipeline failed.")
			return
		stream_button.modulate = Color(1, 1, 1, 0)
		_starting_pipeline = true
		starting_texture_rect.show()
		self.set_physics_process(true)
		self.set_process(true)
	else:
		_reset()

func _on_tree_exited()->void:
	reset()
###########################################################################################
#| END   | signal callbacks |
