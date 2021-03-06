TARGETS = prof.so

OBJECTS = \
					src/callbacks.o \
					src/config.o \
					src/entry.o \
					src/tracer.o

DEPS=$(patsubst %.o,%.d,$(OBJECTS))

ZIPKIN_ROOT=/opt/zipkin-cpp
CXX = g++
CXXFLAGS= -std=c++11 -g -fno-omit-frame-pointer -Wall -Wextra -Wshadow -Wpedantic -fPIC
NVCC=nvcc
NVCCFLAGS= -std=c++11 -g -arch=sm_35 -Xcompiler -Wall,-Wextra,-fPIC,-fno-omit-frame-pointer
INC = -I/usr/local/cuda/include \
      -I/usr/local/cuda/extras/CUPTI/include \
      -I/usr/local/include \
			-Isrc

LIB = -L/usr/local/lib \
      -L/usr/local/cuda/lib \
			-L/usr/local/cuda/extras/CUPTI/lib  \
			-L/usr/local/cuda/extras/CUPTI/lib64  \
			-L/usr/local/cuda/lib64 \
			libzipkin.a \
			-lcupti \
			-lcuda \
			-lcudart \
			-lcudadevrt \
			-ldl \
			-lglog \
			-lfolly \
			-lthrift \
			-lrdkafka++ \
			-lboost_context-mt \
			-lboost_program_options \
			-lboost_thread-mt \
			-lboost_system \
			-lboost_filesystem \
			-lboost_regex-mt \
			-lz \
      -lcurl

all: $(TARGETS)

clean:
	rm -f $(OBJECTS) $(DEPS) $(TARGETS)

prof.so: $(OBJECTS)
	$(CXX) -shared $^ -o $@ $(LIB)

%.o : %.cpp
	cppcheck $<
	$(CXX) -MMD -MP $(CXXFLAGS) $(INC) $< -c -o $@

%.o : %.cu
	$(NVCC) -std=c++11 -arch=sm_35 -dc  -Xcompiler -fPIC $^ -o test.o
	$(NVCC) -std=c++11 -arch=sm_35 -Xcompiler -fPIC -dlink test.o -lcudadevrt -lcudart -o $@

-include $(DEPS)

