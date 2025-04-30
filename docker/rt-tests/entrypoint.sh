#!/bin/bash
source /opt/ros/humble/setup.bash
source /ros2_ws/install/setup.bash

CMD="${1:-cyclictest}"

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

case "$CMD" in
    cyclictest)
        PUBLISH_EVENT start cyclictest
        cyclictest -l 1000000 -i 1000 --json=/output/cyclictest_result.json
        PUBLISH_EVENT done cyclictest
        ;;
    pistress)
        PUBLISH_EVENT start pistress
        pi_stress -g 8 -i 100000
        PUBLISH_EVENT done pistress
        ;;
    signaltest)
        PUBLISH_EVENT start signaltest
        signaltest -p 30 -l 100
        PUBLISH_EVENT done signaltest
        ;;
    *)
        echo "[ERROR] Unknown command"
        ;;
esac