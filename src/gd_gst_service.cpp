#include "gd_gst_service/gd_gst_service.hpp"

using namespace godot;

void GDGstService::_bind_methods() {
	ClassDB::bind_method(D_METHOD("initialize"), &GDGstService::initialize);
	ClassDB::bind_method(D_METHOD("start_pipeline"), &GDGstService::start_pipeline);
	ClassDB::bind_method(D_METHOD("stop_pipeline"), &GDGstService::stop_pipeline);
	ClassDB::bind_method(D_METHOD("is_running"), &GDGstService::is_running);
	ClassDB::bind_method(D_METHOD("get_texture_sample"), &GDGstService::get_texture_sample);
	BIND_CONSTANT(GD_SUCCESS);
	BIND_CONSTANT(GD_ERROR);
}

void GDGstService::_stream_cb(GstMapInfo& map, int& width, int& height) { // TODO add format
	//(void)map, (void)width, (void)height;
	PackedByteArray data;
	data.resize(map.size);
	uint8_t *data_ptr = data.ptrw();
	std::memcpy(data_ptr, map.data, map.size);
	std::lock_guard<std::mutex> lock(_mutex_2d_texture);
	if (_image.is_null() || _image->get_width()!=width || _image->get_height()!=height) {
		gdprint("First time creating image.");
		_image = Image::create(width, height, false, Image::FORMAT_RGB8);
		_2d_texture = ImageTexture::create_from_image(_image);
	}
	_image->set_data(width, height, false, Image::FORMAT_RGB8,  data);
	//_2d_texture = ImageTexture::create_from_image(
	//	Image::create_from_data(width, height, false, Image::FORMAT_RGB8,  data));
}

GDGstService::GDGstService() {
	_gst_service = std::make_shared<GstService>();
	_gst_service->subscribe_to_stream_cb([this](GstMapInfo& map, int& width, int& height) {
			_stream_cb(map, width, height);
		});
	//if (_pipeline_future.valid() && 
	//	_pipeline_future.wait_for(std::chrono::milliseconds(0))!=std::future_status::ready) {
	//	gdprint("Process busy.");
	//	return;
	//}
	//_pipeline_future = std::async(std::launch::async, [this](){
	//		try {
	//		} catch (const std::exception& e) {
	//			//gdprint("Init failed with exception: %s", e.what());
	//			return;
	//		}
	//	});
	gdprint("Construction of GDGstService done.");
}

GDGstService::~GDGstService() {
	gdprint("Destructing GDGstService ..");
	if (_gst_service)
		_gst_service.reset();
	gdprint("Destruction of GDGstService done.");
}

GDExtensionInt GDGstService::initialize() {
	GstServiceConfig config;
	config.source = "srtsrc";

	try {
		_gst_service->initialize(config);
	} catch (std::exception& e) {
		gdprint("Init failed with exception: %s", e.what());
		return GD_ERROR;
	}
	gdprint("Initialize method called!");
	return GD_SUCCESS;
}

GDExtensionInt GDGstService::start_pipeline(const String& uri) {
	gdprint("Start pipeline ..");
	try {
		_gst_service->start_pipeline(uri.utf8().get_data());
	} catch (std::exception& e) {
		gdprint("Failed starting pipeline with exception: %s", e.what());
		return GD_ERROR;
	}
	gdprint("Start pipeline method called!");
	return GD_SUCCESS;
}

GDExtensionInt GDGstService::stop_pipeline() {
	try {
		_gst_service->stop_pipeline();
	} catch (std::exception& e) {
		UtilityFunctions::print(("Exception during stop pipeline: "+std::string(e.what())).c_str());
		return GD_ERROR;
	}
	//try {
	//	_gst_service->close_pipeline();
	//	_gst_service.reset();
	//} catch (std::exception& e) {
	//	UtilityFunctions::print(("Exception during close pipeline: "+std::string(e.what())).c_str());
	//	return GD_ERROR;
	//}
	gdprint("Stop pipeline method called!");
	return GD_SUCCESS;
}

bool GDGstService::is_running() {
	return _gst_service?_gst_service->is_running():false;
}


Ref<Texture2D> GDGstService::get_texture_sample() {
	std::lock_guard<std::mutex> lock(_mutex_2d_texture);
	if (_image.is_valid())
		_2d_texture->update(_image);
	return this->_2d_texture;
}