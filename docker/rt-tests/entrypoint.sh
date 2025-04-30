#!/bin/bash
source /opt/ros/humble/setup.bash
source /ros2_ws/install/setup.bash

CMD="${CMD:-cyclictest}"

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

# 테스트 인자 환경 변수에서 가져오기
CYCLICTEST_ARGS="${CYCLICTEST_ARGS:--l 10000 -i 1000 --json=/output/cyclictest_result.json}"
PISTRESS_ARGS="${PISTRESS_ARGS:--g 8 -i 100000}"
SIGNALTEST_ARGS="${SIGNALTEST_ARGS:--p 30 -l 100}"

case "$CMD" in
    cyclictest)
        PUBLISH_EVENT start cyclictest
        cyclictest $CYCLICTEST_ARGS
        PUBLISH_EVENT done cyclictest
        ;;
    pistress)
        PUBLISH_EVENT start pistress
        pi_stress $PISTRESS_ARGS
        PUBLISH_EVENT done pistress
        ;;
    signaltest)
        PUBLISH_EVENT start signaltest
        signaltest $SIGNALTEST_ARGS
        PUBLISH_EVENT done signaltest
        ;;
    *)
        echo "[ERROR] Unknown command: $CMD"
        ;;
esac
