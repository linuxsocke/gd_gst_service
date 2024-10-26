#include <string>
#include <iostream>
#include <stdexcept>
#include <thread>
#include <memory>
#include <chrono>

#include <signal.h>
#include <stdlib.h>

#include "gd_gst_service/gst_service/gst_service.hpp"
//#include "gd_gst_service/gd_gst_service.hpp"

bool running = false;

static void stopHandler(int sign) {
    (void)sign;
    std::cerr << "received ctrl-c\n";
    running = false;
}

int main(int, char*[]) {
	signal(SIGINT, stopHandler);
    signal(SIGTERM, stopHandler);
    std::cout << "Testing gst service." << std::endl;

	auto gst_service = std::make_shared<GstService>(true);

	GstServiceConfig config;
	config.source = "srtsrc";

    gst_service->subscribe_to_stream_cb([](GstMapInfo&, int& width, int& height) {
            std::cerr << "Receiving map [ width: " << width << ", height: " << height << "]\n";
        });

	try {
		gst_service->initialize(config);
	} catch (std::exception& e) {
        std::cout << "Gst service initialization failed with exception: "+std::string(e.what()) << std::endl;
		return -1;
	}
	try {
		gst_service->start_pipeline("srt://127.0.0.1:8888");
	} catch (std::exception& e) {
		std::cout << "Gst service start pipeline call failed with exception: "+std::string(e.what()) << std::endl;
		return -1;
	}

	running = true;
    std::cout << "Initialized. Starting iterations." << std::endl;
    while(running) {
        // - needed in oder to process interrupt cb
        std::this_thread::sleep_for(std::chrono::milliseconds(1000));
    }

	try {
		gst_service->stop_pipeline();
	} catch (std::exception& e) {
        std::cout << "Gst service stop pipeline call failed with exception: "+std::string(e.what()) << std::endl;
		return -1;
	}

    std::cout << "Shutting down gst service .. " << std::endl;
    return 0;
}