# tracepp [![Build Status](https://travis-ci.org/rai-project/tracepp.svg?branch=master)](https://travis-ci.org/rai-project/tracepp)

This is an example of how to combine CUPTI, LD_PRELOAD, zipkin-cpp, and OpenZipkin to record a zipkin trace for every CUDA API call.

## Setup

Install [zipkin-cpp](https://github.com/flier/zipkin-cpp)

Install the CUDA sdk.

Build the vector add example (lifted from the CUDA SDK)

    cd examples/vectorAdd && make

Install [docker](https://www.docker.com/get-docker)

## Using

Run zipkin

    docker run -d -p 9411:9411 openzipkin/zipkin

`env.sh` sets up the `LD_PRELOAD` environment before calling whatever arguments it is provided. For example:

    ./env.sh examples/vectorAdd/vec

Navigate your web browser to `localhost:9411` and look at the traces!

## Other Info

`callbacks.cpp` defines callback functions that are executed by CUPTI. It also defines a function that initializes CUPTI.

`preload_cudart.cpp` defines verions of some CUDA runtime functions that the LD_PRELOAD mechanism will use instead of the actual CUDA runtime functions.

## MacOSX

On MacOSX you cannot use `LD_PRELOAD` to load the library you'd want to do something lik

    DYLD_INSERT_LIBRARIES=prof.so DYLD_FORCE_FLAT_NAMESPACE=1
