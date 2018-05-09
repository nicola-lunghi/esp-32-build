FROM ubuntu:16.04

# Install build dependencies (and vim + picocom for editing/debugging)
RUN apt-get -qq update \
    && apt-get install -y gcc git wget make libncurses-dev flex bison gperf python python-serial \
                          vim picocom \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Get the ESP32 toolchain and extract it to /esp/xtensa-esp32-elf
RUN mkdir -p /opt/local/espressif
WORKDIR /opt/local/espressif

RUN wget -O /tmp/esp32-toolchain.tar.gz https://dl.espressif.com/dl/xtensa-esp32-elf-linux64-1.22.0-80-g6c4433a-5.2.0.tar.gz \
    && tar -xzf /tmp/esp32-toolchain.tar.gz -C /opt/local/espressif \
    && rm /tmp/esp32-toolchain.tar.gz

RUN wget -O /tmp/esp32ulp-toolchain.tar.gz https://dl.espressif.com/dl/esp32ulp-elf-binutils-linux64-d2ae637d.tar.gz \
    && tar -xzf /tmp/esp32ulp-toolchain.tar.gz -C /opt/local/espressif \
    && rm /tmp/esp32ulp-toolchain.tar.gz

# Setup i esp-idf
ENV IDF_PATH /esp-idf
RUN mkdir -p $IDF_PATH \
 && git clone --recursive https://github.com/espressif/esp-idf.git \
              $IDF_PATH

# Setup environment variables
ENV PATH /opt/local/espressif/xtensa-esp32-elf/bin:/opt/local/espressif/esp32ulp-elf-binutils/bin:$IDF_PATH/tools:$PATH

# This is the directory where our project will show up
RUN mkdir -p /projects
WORKDIR /projects
ENTRYPOINT ["/bin/bash"]
