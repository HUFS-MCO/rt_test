FROM ros:humble-ros-core

# --------- 1. 시스템 및 ROS2 빌드 의존성 설치 ---------
RUN apt update && apt install -y \
    python3-pip \
    python3-colcon-common-extensions \
    ros-humble-rclpy \
    ros-humble-std-msgs \
    && rm -rf /var/lib/apt/lists/*

# --------- 2. 작업 공간 복사 및 메시지 빌드 ---------
COPY ../../ros2_ws /ros2_ws
WORKDIR /ros2_ws
RUN . /opt/ros/humble/setup.sh && \
    colcon build --packages-select monitor_msgs

# --------- 3. 모니터링 노드 복사 ---------
COPY ../../docker/monitor/monitor_node.py /ros2_ws/monitor_node.py

# --------- 4. 환경 설정 ---------
ENV ROS_PACKAGE_PATH=/ros2_ws/install
ENV COLCON_PREFIX_PATH=/ros2_ws/install
# 빌드 후 install 위치에 환경 변수 설정 추가
SHELL ["/bin/bash", "-c"]
RUN echo "source /opt/ros/humble/setup.bash && source /ros2_ws/install/setup.bash" >> ~/.bashrc
ENV PYTHONPATH=/ros2_ws/install/monitor_msgs_py/lib/python3.10/site-packages:$PYTHONPATH
ENV ROS_PACKAGE_PATH=/ros2_ws/install:$ROS_PACKAGE_PATH

# --------- 5. 기본 작업 디렉토리 및 실행 ---------
WORKDIR /ros2_ws
ENTRYPOINT ["/bin/bash", "-c", \
  "source /opt/ros/humble/setup.bash && \
   source /ros2_ws/install/setup.bash && \
   export PYTHONPATH=/ros2_ws/install/monitor_msgs_py/lib/python3.10/site-packages:$PYTHONPATH && \
   python3 /ros2_ws/monitor_node.py"]