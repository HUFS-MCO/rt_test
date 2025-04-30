import rclpy
from rclpy.node import Node
from monitor_msgs.msg import TestEvent
from datetime import datetime

class MonitorNode(Node):
    def __init__(self):
        super().__init__('monitor_node')
        self.create_subscription(TestEvent, '/test_event', self.event_callback, 10)

    def event_callback(self, msg):
        ts = msg.timestamp.sec + msg.timestamp.nanosec / 1e9
        time_str = datetime.fromtimestamp(ts).isoformat()
        self.get_logger().info(f"[{time_str}] {msg.phase.upper()} for {msg.test_name}")

def main(args=None):
    rclpy.init(args=args)
    node = MonitorNode()
    rclpy.spin(node)
    node.destroy_node()
    rclpy.shutdown()

if __name__ == '__main__':
    main()