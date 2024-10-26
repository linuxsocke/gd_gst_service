#ifndef GD_EXTENSION_GST_PLAYER
#define GD_EXTENSION_GST_PLAYER

#include <iostream>
#include <string>
#include <functional>
#include <atomic>
#include <thread>
#include <mutex>

#include <gst/gst.h>

struct GstServiceConfig {
    std::string source{""};
    std::string image_format{"RGB"};
    std::string frame_rate{""}; // e.g.: 30/1
};

class GstService {
private:
    void _iterate_bus_msgs();
    void _get_stream_sample();
    void _run();

    GstServiceConfig _config;

    GstBus     *_bus{NULL};

    GstElement *_pipeline{NULL};
    GstElement *_source  {NULL};
    GstElement *bin      {NULL};
    GstElement *decoder  {NULL};
    GstElement *_appsink {NULL};
    GstElement *_convert {NULL};

    std::atomic<bool> _pipeline_connected{false};

    std::thread _gst_thread;
    std::atomic<bool> _running{false};

    std::function<void(GstMapInfo&, int&, int&)> _map_cb;

public:
    GstService(bool activate_debug=true);
    ~GstService();

    void initialize(const GstServiceConfig& config);

    void subscribe_to_stream_cb(std::function<void(GstMapInfo&, int&, int&)> cb){
        _map_cb = cb;
    }

    void handle_pad_added(GstElement *, GstPad *new_pad);
    // TODO for video quicktime decoder missing
    //void play_video(const std::string &uri);
    void start_pipeline(const std::string &uri);
    void stop_pipeline();
    void close_pipeline();

    bool is_running();

};

#endif