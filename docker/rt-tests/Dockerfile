FROM ros:humble-ros-core

# --------- 1. 시스템 및 빌드 도구 설치 ---------
RUN apt update && apt install -y \
    build-essential \
    git \
    cmake \
    numactl \
    libnuma-dev \
    libcap-dev \
    libncurses5-dev \
    util-linux \
    curl \
    python3-pip \
    python3-colcon-common-extensions \
    ros-humble-std-msgs \
    && rm -rf /var/lib/apt/lists/*

# --------- 2. rt-tests 설치 (fork 가능) ---------
RUN git clone https://github.com/HUFS-MCO/rt_test.git /opt/rt-tests && \
    cd /opt/rt-tests && \
    make && make install

# --------- 3. ROS 2 메시지 빌드 ---------
# 작업공간 복사 및 빌드
COPY ../../ros2_ws /ros2_ws
WORKDIR /ros2_ws
RUN . /opt/ros/humble/setup.sh && \
    colcon build --packages-select monitor_msgs

# --------- 4. entrypoint 복사 ---------
COPY ../../docker/rt-tests/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# --------- 5. ROS 설정 환경 구성 ---------
ENV ROS_PACKAGE_PATH=/ros2_ws/install
ENV COLCON_PREFIX_PATH=/ros2_ws/install
SHELL ["/bin/bash", "-c"]
RUN echo "source /opt/ros/humble/setup.bash && source /ros2_ws/install/setup.bash" >> ~/.bashrc

# --------- 6. 작업 디렉토리 및 시작 ---------
WORKDIR /opt/rt-tests
ENTRYPOINT ["/bin/bash", "-c", "/usr/local/bin/entrypoint.sh \"$test_name\""]