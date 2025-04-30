cmake_minimum_required(VERSION 3.5)
project(monitor_msgs)

find_package(ament_cmake REQUIRED)
find_package(rosidl_default_generators REQUIRED)
find_package(builtin_interfaces REQUIRED)
find_package(ament_cmake_python REQUIRED)

rosidl_generate_interfaces(${PROJECT_NAME}
  "msg/TestEvent.msg"
  DEPENDENCIES builtin_interfaces
)
ament_python_install_package(monitor_msgs_py)

ament_package()