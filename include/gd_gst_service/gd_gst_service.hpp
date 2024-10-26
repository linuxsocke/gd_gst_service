#ifndef GD_EXTENSION_GD_GST_SERVICE
#define GD_EXTENSION_GD_GST_SERVICE

#include <memory>
#include <future>
#include <functional>
#include <mutex>
#include <atomic>
#include <stdexcept>

#include <godot_cpp/classes/image.hpp>
#include <godot_cpp/classes/image_texture.hpp>
#include <godot_cpp/classes/ref_counted.hpp>
#include <godot_cpp/classes/texture2d.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

#include "gd_gst_service/formatter.hpp"
#include "gd_gst_service/gst_service/gst_service.hpp"

enum ResultCode {
	GD_SUCCESS,
	GD_ERROR
};

using namespace godot;

class GDGstService : public RefCounted {
	GDCLASS(GDGstService, RefCounted)

private:
	template<typename... Args>
	void gdprint(const std::string& format_str, Args... args) {
		try {
			std::vector<std::string> arg_strings = {Formatter::to_string(args)...};
			std::string formatted_str = Formatter::vformat(std::string("[GDGstService] ")+format_str, arg_strings);
			UtilityFunctions::print(formatted_str.c_str());
		} catch (std::exception& e) {
			String error_msg = ("[GDGstService] Formatter exception: "+std::string(e.what())).c_str();
			UtilityFunctions::print(error_msg);
		}
	}

	void _stream_cb(GstMapInfo&, int&, int&);

	std::future<void> _pipeline_future{std::future<void>()};

	Ref<Image> _image;
	Ref<ImageTexture> _2d_texture;
	std::mutex _mutex_2d_texture;

	std::shared_ptr<GstService> _gst_service;

protected:
	static void _bind_methods();

public:
	GDGstService();
	~GDGstService();

	Ref<Texture2D> get_texture_sample();

	GDExtensionInt initialize();

	GDExtensionInt start_pipeline(const String&);
	GDExtensionInt stop_pipeline();

	bool is_running();

};

#endif