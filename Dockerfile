# Step 1: Download and use an existing docker image as a base
FROM balenalib/raspberry-pi-debian:latest

# Step 2: Download and install dependency
RUN export DEBIAN_FRONTEND=noninteractive
RUN apt-get update
#RUN apt-get install python-pip
#
RUN apt-get install python-empy
RUN apt install -y lsb-release
RUN apt install -y python-setuptools

# Installation of ROS

RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
RUN echo "Installing dependances"
RUN apt install -y python-rosdep python-rosinstall-generator python-wstool python-rosinstall build-essential cmake
RUN rosdep init
RUN rosdep update
RUN mkdir -p ~/ros_catkin_ws
RUN cd ~/ros_catkin_ws
RUN rosinstall_generator ros_comm --rosdistro melodic --deps --wet-only --tar > melodic-ros_comm-wet.rosinstall
RUN wstool init src melodic-ros_comm-wet.rosinstall
#
RUN rosinstall_generator perception --rosdistro melodic --deps --wet-only --tar > melodic-custom_ros.rosinstall
RUN wstool merge -t src melodic-custom_ros.rosinstall
RUN wstool update -t src
#
RUN  rosdep install -y --from-paths src --ignore-src --rosdistro melodic -r --os=debian:buster
RUN ./src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release --install-space /opt/ros/melodic
RUN  echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc

# Step 3: Tell the image what to do when it starts as container

CMD ["ls"]