#include "gd_gst_service/gst_service/gst_service.hpp"

#include <chrono>
#include <stdexcept>

#include <gst/gstplugin.h>
#include <gst/gstmessage.h>

#include <gst/app/gstappsink.h>

static const std::string GST_APP_SINK = "appsink";
static const std::string GST_VIDEO_CONVERT = "videoconvert";

// Declare external symbols for static plugins
extern "C" {
    GST_PLUGIN_STATIC_DECLARE(coreelements);       // Plugin includes: queue, filesrc, etc.
    GST_PLUGIN_STATIC_DECLARE(playback);           // Plugin includes: decodebin, etc.
    GST_PLUGIN_STATIC_DECLARE(videoconvertscale);  // Plugin includes: videoconvert
    GST_PLUGIN_STATIC_DECLARE(autodetect);         // Plugin includes: autovideosrc, etc
    GST_PLUGIN_STATIC_DECLARE(ximagesink);         // Plugin includes: ximagesink
    GST_PLUGIN_STATIC_DECLARE(app);                // Plugin includes: appsink
    GST_PLUGIN_STATIC_DECLARE(typefindfunctions);  // Plugin includes: typefindfunctions
    GST_PLUGIN_STATIC_DECLARE(srt);                // Plugin includes: srtsrc
    GST_PLUGIN_STATIC_DECLARE(mpegtsdemux);        // Plugin includes: MPEG
    GST_PLUGIN_STATIC_DECLARE(videoparsersbad);    // Plugin includes: h264parse, etc.
    GST_PLUGIN_STATIC_DECLARE(openh264);           // Plugin includes: H.264
}

#ifdef STATIC_GSTREAMER
static void register_static_plugins() {
    GST_PLUGIN_STATIC_REGISTER(coreelements);
    GST_PLUGIN_STATIC_REGISTER(playback);
    GST_PLUGIN_STATIC_REGISTER(videoconvertscale);
    GST_PLUGIN_STATIC_REGISTER(autodetect);
    GST_PLUGIN_STATIC_REGISTER(ximagesink);         
    GST_PLUGIN_STATIC_REGISTER(app);
    GST_PLUGIN_STATIC_REGISTER(srt);
    GST_PLUGIN_STATIC_REGISTER(typefindfunctions);
    GST_PLUGIN_STATIC_REGISTER(mpegtsdemux); 
    GST_PLUGIN_STATIC_REGISTER(videoparsersbad);
    GST_PLUGIN_STATIC_REGISTER(openh264); 
}
#endif

GstService::GstService(bool activate_debug){
    if (activate_debug) {
        setenv("GST_DEBUG", "*:4", 1);
    }
    gst_init(nullptr, nullptr);
#ifdef STATIC_GSTREAMER
    register_static_plugins();
#endif
    gst_debug_set_active(1);
}

GstService::~GstService(){
    stop_pipeline();
    close_pipeline();
}

void  GstService::handle_pad_added(GstElement *, GstPad *new_pad) {
    g_print("Dynamic pad created, linking decodebin/sink ..\n");
    GstPad *sink_pad = gst_element_get_static_pad(_convert, "sink");
    if (gst_pad_is_linked(sink_pad)) {
        gst_object_unref(sink_pad);
        return;
    }

    GstPadLinkReturn ret = gst_pad_link(new_pad, sink_pad);
    if (GST_PAD_LINK_FAILED(ret)) {
        g_printerr("Type is not compatible.\n");
    } else {
        g_print("Link succeeded (type).\n");
    }

    gst_object_unref(sink_pad);
    _pipeline_connected.store(true);
}

void GstService::initialize(const GstServiceConfig& config) {
    _config = config;

    _source                  = gst_element_factory_make(config.source.c_str(), "source");
    decoder      = gst_element_factory_make("decodebin"          , "decoder");
    _convert                 = gst_element_factory_make("videoconvert"       , "videoconvert");
    _appsink                 = gst_element_factory_make("appsink"            , "sink");
    //GstElement* queue = gst_element_factory_make("queue", "queue");

    if (!_source) {
        throw std::runtime_error("source could not be created.\n");
    }
    if (!decoder) {
        throw std::runtime_error("decodebin could not be created.\n");
    }
    if (!_convert) {
        throw std::runtime_error("videoconvert could not be created.\n");
    }
    if (!_appsink) {
        throw std::runtime_error("sink could not be created.\n");
    }
    //if (!queue) {
    //    throw std::runtime_error("queue");
    //}

    _pipeline = gst_pipeline_new("video-pipeline");
    //gst_bin_add_many(GST_BIN(_pipeline), _source, decoder, queue, videoconvert, _appsink, nullptr);
    gst_bin_add_many(GST_BIN(_pipeline), _source, decoder, _convert, _appsink, nullptr);

    if (!gst_element_link(_source, decoder)) {
        gst_object_unref(_pipeline);
        throw std::runtime_error("Elements could not be linked (source -> decodebin).\n");
    }

    //if (!gst_element_link_many(queue, videoconvert, _appsink, nullptr)) {
    if (!gst_element_link(_convert, _appsink)) {
        gst_object_unref(_pipeline);
        throw std::runtime_error("Elements could not be linked (videoconvert -> sink).\n");
    }

    // Connect the decodebin to the videoconvert dynamically
    g_signal_connect(decoder, "pad-added", G_CALLBACK(+[](GstElement *element, GstPad *pad, gpointer context) {
            GstService *self = static_cast<GstService*>(context);
            self->handle_pad_added(element, pad);
        }), this);
    //g_signal_connect(decoder, "pad-added", G_CALLBACK(_on_pad_added), this);

    std::string frame_caps_string = std::string("video/x-raw");
    if (_config.image_format!="") {
        frame_caps_string += ", format="+_config.image_format;
    }
    if (_config.frame_rate!="") {
        frame_caps_string += ", framerate="+_config.frame_rate;
    }
    GstCaps* caps = gst_caps_from_string(frame_caps_string.c_str());
    if (!caps) {
        throw(std::runtime_error("Could not create appsink caps"));
    }
    gst_app_sink_set_caps(GST_APP_SINK(_appsink), caps);
    gst_caps_unref(caps);

    // Wait until error or EOS
    _bus = gst_element_get_bus(_pipeline);

}

void GstService::_iterate_bus_msgs() {
    GstMessage *msg{nullptr};
    msg = gst_bus_pop_filtered(_bus,
        static_cast<GstMessageType>(GST_MESSAGE_ERROR | GST_MESSAGE_EOS));
    if (!msg) {
        return;
    }

    GError *err{nullptr};
    gchar *debug_info{nullptr};
    switch (GST_MESSAGE_TYPE(msg)) {
        case GST_MESSAGE_ERROR:
            gst_message_parse_error(msg, &err, &debug_info);
            g_printerr("Error received from element %s: %s\n", GST_OBJECT_NAME (msg->src), err->message);
            g_printerr("Debugging information: %s\n", debug_info ? debug_info : "none");
            g_clear_error(&err);
            g_free(debug_info);
            break;
        case GST_MESSAGE_EOS:
            g_print("End-Of-Stream reached.\n");
            break;
        case GST_MESSAGE_UNKNOWN:
        case GST_MESSAGE_WARNING:
        case GST_MESSAGE_INFO:
        case GST_MESSAGE_ANY:
        default:

            g_printerr("Unexpected message received.\n");
            break;
    }
}

void GstService::_get_stream_sample(){
    // Retrieve and parse the image data from GStreamer and create a Godot texture
    GstSample *sample = gst_app_sink_pull_sample(GST_APP_SINK(_appsink));
    if (sample) {
        GstCaps *caps = gst_sample_get_caps(sample);
        GstStructure *s = gst_caps_get_structure(caps, 0);
        gst_structure_get_string(s, "format");
        int width, height;
        gst_structure_get_int(s, "width", &width);
        gst_structure_get_int(s, "height", &height);
        //std::cerr << "Receiving map [ width: " << width << ", height: " << height << "]\n";

        GstBuffer *buffer = gst_sample_get_buffer(sample);
        GstMapInfo map;
        if(gst_buffer_map(buffer, &map, GST_MAP_READ)){
            if (_map_cb){
                _map_cb(map, width, height);
            }
            gst_buffer_unmap(buffer, &map);
        }

        gst_sample_unref(sample);
    } else {
        g_printerr("No sample\n");
    }
}

void GstService::_run() {
    _running.store(true);
    GstState state;
    do {
        try {
            _iterate_bus_msgs();
        } catch (std::exception& e) {
            std::cerr << "Gst service iter bus msgs failed with exception: "+std::string(e.what()) << std::endl;
            _running.store(false);
            break;
        }
        if (!_pipeline_connected.load()) continue;
        gst_element_get_state(_pipeline, &state, nullptr, GST_CLOCK_TIME_NONE);
        switch (state) {
        case GST_STATE_PLAYING:
            try {
                _get_stream_sample();
            } catch (std::exception& e) {
                std::cerr << "Gst service get stream sample failed with exception: "+std::string(e.what()) << std::endl;
                _running.store(false);
            }
            break;
        case GST_STATE_NULL:
            _running.store(false);
            break;
        case GST_STATE_VOID_PENDING:
        case GST_STATE_READY:
        case GST_STATE_PAUSED:
        default:
            continue;
        }
    } while(_running.load());
    std::clog << "GstService | exiting run loop.\n";
}

void GstService::start_pipeline(const std::string &uri) {
    if (_pipeline==nullptr) 
        throw std::runtime_error("Pipeline not initialized. Not starting stream.");
    if (_config.source != "srtsrc") 
        throw std::runtime_error("Source is not configured as srtsrc. Not receiving srt stream.");
    _pipeline_connected.store(false);
    g_object_set(_source, "uri", uri.c_str(), "latency", 100, NULL);
    g_object_set(_appsink, "sync", FALSE, "throttle-time", 0, NULL);

    GstStateChangeReturn ret = gst_element_set_state(_pipeline, GST_STATE_PLAYING);
    if (ret == GST_STATE_CHANGE_FAILURE) {
        throw(std::runtime_error("Could not start pipeline"));
    }

    if (_running.load()) return;
    _gst_thread = std::thread(&GstService::_run, this);
}

void GstService::stop_pipeline() {
    _running.store(false);
    _pipeline_connected.store(false);
    if (_gst_thread.joinable()) {
        _gst_thread.join();
    }
    
    if (_pipeline) {
        GstStateChangeReturn ret = gst_element_set_state(_pipeline, GST_STATE_NULL);
	    if (ret == GST_STATE_CHANGE_FAILURE) {
            throw(std::runtime_error("Could not stop pipeline"));
        }
    }
    std::clog << "GstService | Stopped pipeline\n";
}

void GstService::close_pipeline() {
    if (_bus)
        gst_object_unref(_bus);
    if (_pipeline) {
        gst_element_set_state(_pipeline, GST_STATE_NULL);
        gst_object_unref(_pipeline);
    }
}

bool GstService::is_running() { 
    if (!_pipeline_connected.load()) return false;
    return _running.load(); 
}