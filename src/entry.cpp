#include "callbacks.hpp"
#include "tracer.hpp"

static void onEntry() __attribute__((constructor));

void onEntry() {
    // Tracer::instance();
    printf("activating callbacks..\n");
    onceActivateCallbacks();
}
