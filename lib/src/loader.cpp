#include "callbacks.hpp"

static void onEntry() __attribute__((constructor)) {
  printf("calling onEntry..\n");
  onceActivateCallbacks();
}

static void onExit() __attribute__((destructor)) {
  printf("calling onExit..\n");
}
