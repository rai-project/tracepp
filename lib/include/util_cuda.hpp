#ifndef __TRACEPP_UTIL_CUDA_HPP__
#define __TRACEPP_UTIL_CUDA_HPP__

#include <cuda_runtime.h>
#include <cstdio>
#include <cstdlib>

#define CUDA_CHECK(ans) \
  { gpuAssert((ans), __FILE__, __LINE__); }
static inline void gpuAssert(cudaError_t code, const char *file, int line,
                             bool abort = true) {
  if (code != cudaSuccess) {
    fprintf(stderr, "CUDA_CHECK: %s %s %d\n", cudaGetErrorString(code), file,
            line);
    if (abort) exit(code);
  }
}

#endif  // __TRACEPP_UTIL_CUDA_HPP__
