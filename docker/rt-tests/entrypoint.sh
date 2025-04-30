#!/bin/bash
source /opt/ros/humble/setup.bash
source /ros2_ws/install/setup.bash

PUBLISH_EVENT() {
    local PHASE=$1
    local TEST_NAME=$2

    now_sec=$(date +%s)
    now_nsec=$(date +%N | cut -c1-9)

    ros2 topic pub --once /test_event monitor_msgs/msg/TestEvent "{
      timestamp: { sec: $now_sec, nanosec: $now_nsec },
      phase: '$PHASE',
      test_name: '$TEST_NAME'
    }"
}

RUN_TEST() {
    local CMD=$1
    local ARGS_VAR_NAME=$2
    local ARGS=${!ARGS_VAR_NAME}

    PUBLISH_EVENT start $CMD
    $CMD $ARGS
    PUBLISH_EVENT done $CMD
}

if [ "$CMD" == "all" ]; then
    RUN_TEST cyclictest CYCLICTEST_ARGS
    RUN_TEST pi_stress PISTRESS_ARGS
    RUN_TEST signaltest SIGNALTEST_ARGS
else
    RUN_TEST $CMD ${CMD^^}_ARGS
fi
