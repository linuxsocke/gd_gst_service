#include <gst/gst.h>
#include <iostream>

static void on_pad_added(GstElement*, GstPad *pad, gpointer data) {
    GstPad *sinkpad;
    GstElement *videoconvert = (GstElement *)data;

    g_print("Dynamic pad created, linking decodebin/sink\n");

    sinkpad = gst_element_get_static_pad(videoconvert, "sink");

    if (gst_pad_link(pad, sinkpad) != GST_PAD_LINK_OK) {
        g_printerr("Failed to link decodebin to videoconvert.\n");
    }

    gst_object_unref(sinkpad);
}

int main(int argc, char *argv[]) {
    GstElement *pipeline, *source, *decodebin, *videoconvert, *sink;
    GstBus *bus;
    GstMessage *msg;
    //GError *error = nullptr;

    // Initialize GStreamer
    gst_init(&argc, &argv);

    // Create the elements
    source = gst_element_factory_make("srtsrc", "source");
    decodebin = gst_element_factory_make("decodebin", "decodebin");
    videoconvert = gst_element_factory_make("videoconvert", "videoconvert");
    sink = gst_element_factory_make("autovideosink", "sink");

    if (!source || !decodebin || !videoconvert || !sink) {
        g_printerr("Not all elements could be created.\n");
        return -1;
    }

    // Create the empty pipeline
    pipeline = gst_pipeline_new("test-pipeline");

    if (!pipeline) {
        g_printerr("Pipeline could not be created.\n");
        return -1;
    }

    // Build the pipeline
    gst_bin_add_many(GST_BIN(pipeline), source, decodebin, videoconvert, sink, NULL);
    if (!gst_element_link(source, decodebin)) {
        g_printerr("Elements could not be linked (source -> decodebin).\n");
        gst_object_unref(pipeline);
        return -1;
    }

    if (!gst_element_link(videoconvert, sink)) {
        g_printerr("Elements could not be linked (videoconvert -> sink).\n");
        gst_object_unref(pipeline);
        return -1;
    }

    // Connect the decodebin to the videoconvert dynamically
    g_signal_connect(decodebin, "pad-added", G_CALLBACK(on_pad_added), videoconvert);

    // Set the properties
    g_object_set(source, "uri", "srt://127.0.0.1:8888", "latency", 100, NULL);
    g_object_set(sink, "sync", FALSE, "throttle-time", 0, NULL);

    // Start playing
    gst_element_set_state(pipeline, GST_STATE_PLAYING);

    // Wait until error or EOS
    bus = gst_element_get_bus(pipeline);
    msg = gst_bus_timed_pop_filtered(bus, GST_CLOCK_TIME_NONE,
                                     static_cast<GstMessageType>(GST_MESSAGE_ERROR | GST_MESSAGE_EOS));

    // Parse message
    if (msg != nullptr) {
        GError *err;
        gchar *debug_info;

        switch (GST_MESSAGE_TYPE(msg)) {
        case GST_MESSAGE_ERROR:
            gst_message_parse_error(msg, &err, &debug_info);
            g_printerr("Error received from element %s: %s\n", GST_OBJECT_NAME(msg->src), err->message);
            g_printerr("Debugging information: %s\n", debug_info ? debug_info : "none");
            g_clear_error(&err);
            g_free(debug_info);
            break;
        case GST_MESSAGE_EOS:
            g_print("End-Of-Stream reached.\n");
            break;
        default:
            // Should not reach here
            g_printerr("Unexpected message received.\n");
            break;
        }
        gst_message_unref(msg);
    }

    // Free resources
    gst_object_unref(bus);
    gst_element_set_state(pipeline, GST_STATE_NULL);
    gst_object_unref(pipeline);
    return 0;
}
