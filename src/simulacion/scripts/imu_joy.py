#!/usr/bin/env python3
import rospy
import serial
from geometry_msgs.msg import Twist
from tf.transformations import euler_from_quaternion

def main():
    # Inicializa ROS
    rospy.init_node("pioneer_wii_control")

    # Publicador de velocidad hacia el Pioneer 3-AT simulado
    pub = rospy.Publisher("/sim_p3at/cmd_vel", Twist, queue_size=10)

    # Configura el puerto serie (ajusta según tu IMU)
    ser = serial.Serial("/dev/ttyUSB0", baudrate=115200, timeout=0.1)

    rate = rospy.Rate(20)  # 20 Hz

    while not rospy.is_shutdown():
        try:
            line = ser.readline().decode("utf-8").strip()
            if not line:
                continue

            # Se espera el formato: qw qx qy qz gx gy gz ax ay az
            data = line.split()
            if len(data) < 10:
                continue

            qw, qx, qy, qz = map(float, data[0:4])

            # Convierte a ángulos de Euler (rad)
            roll, pitch, yaw = euler_from_quaternion([qx, qy, qz, qw])

            # Genera comando de velocidad tipo "Wii control"
            twist = Twist()

            # Pitch -> movimiento hacia adelante/atrás
            twist.linear.x = 0.5 * pitch  

            # Roll -> giro a izquierda/derecha
            twist.angular.z = -1.0 * roll  

            # Publica en el tópico del Pioneer
            pub.publish(twist)

        except Exception as e:
            rospy.logwarn(f"Error leyendo/parsing datos: {e}")

        rate.sleep()

if __name__ == "__main__":
    try:
        main()
    except rospy.ROSInterruptException:
        pass

