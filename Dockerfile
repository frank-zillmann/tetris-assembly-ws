FROM osrf/ros:humble-desktop

SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive
ENV ROS_DISTRO=humble
ENV WS=/workspaces/mirte_ws
# Default ROS Domain ID for discovery (can be overridden via docker-compose.yml)
ENV ROS_DOMAIN_ID=0
# Allow communication with remote ROS nodes
ENV ROS_LOCALHOST_ONLY=0

# Basic development tools
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    vim \
    nano \
    build-essential \
    python3-pip \
    python3-vcstool \
    python3-rosdep \
    python3-colcon-common-extensions \
    iputils-ping \
    net-tools \
    netcat \
    openssh-client \
    ros-dev-tools \
    mesa-utils \
    && rm -rf /var/lib/apt/lists/*

# Gazebo Classic is what MIRTE documents currently support
RUN apt-get update && apt-get install -y \
    gazebo \
    ros-humble-gazebo-ros-pkgs \
    ros-humble-gazebo-ros2-control \
    ros-humble-xacro \
    ros-humble-joint-state-publisher \
    ros-humble-joint-state-publisher-gui \
    ros-humble-robot-state-publisher \
    ros-humble-teleop-twist-keyboard \
    ros-humble-ros2-control \
    ros-humble-ros2-controllers \
    libgl1-mesa-dri \
    libegl1-mesa \
    libgbm1 \
    && rm -rf /var/lib/apt/lists/*

# rosdep init is safe to attempt once
RUN rosdep init || true
RUN rosdep update

# Workspace
RUN mkdir -p ${WS}/src
WORKDIR ${WS}

# Convenience - Auto-source ROS and workspace setup on shell startup
RUN echo "source /opt/ros/humble/setup.bash" >> /root/.bashrc && \
    echo "echo 'ROS_DOMAIN_ID: '\$ROS_DOMAIN_ID" >> /root/.bashrc && \
    echo "[ -f ${WS}/install/setup.bash ] && source ${WS}/install/setup.bash" >> /root/.bashrc
CMD ["/bin/bash"]
