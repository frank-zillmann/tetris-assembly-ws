# PC/Laptop Workspace for the tetris assembly task (Group 4) with MRITE Master
Main purposes:
- Dockerfile + docker-compose.yml
- Git Submodules
- Frequent commands/scripts for development and testing

## Cloning with Git Submodule
```bash
git clone --recurse-submodules https://github.com/frank-zillmann/tetris-assembly-ws.git

# Alternative if already cloned without --recurse-submodules
git submodule update --init --recursive
```

## GPU Configuration

**Default setup:** AMD/Intel iGPU support is enabled via `/dev/dri` passthrough.

For **NVIDIA GPU**, you should change `docker-compose.yml` and ensure `nvidia-docker` is installed. But I have not tested this!

## Build and Run Docker Container

```bash
# Build the container image
docker compose build

# Start container (first time or after docker compose down)
docker compose up -d

# Enter the container
docker compose exec tetris-assembly-dev bash

# Stop container (keep state)
docker compose stop

# Start again later
docker compose start

# Remove container (resets container state)
docker compose down

# Verify GPU support (run inside container)
glxinfo | grep "OpenGL renderer"
# Should show GPU name (not "llvmpipe" software renderer)
```

## Install Dependencies and Build (Inside Container)

```bash
cd /workspaces/mirte_ws

# Install dependencies
apt-get update
rosdep update
rosdep install --from-paths src --ignore-src -r -y

# Build workspace
colcon build
# Alternative using minimal resources
MAKEFLAGS="-j1" colcon build --parallel-workers 1

# Source the workspace
source install/setup.bash
```

## Other
Rewrite ownership in case of permission issues:
```bash
sudo chown -R $(id -u):$(id -g) .
```

Alternatively to Docker, you can use singularity image from other course (https://manual.ro47014.me.tudelft.nl/krr_course/krr_setup_instruction.html).

```bash
singularity pull -F ro47014_humble_v3.sif oras://registry.tudelft.nl/cor_ro47014_krr_image/singularity_image:v3

singularity shell -p ro47014_humble_v3.sif

source /krr/krr_base_ws/install/setup.bash

# only build tetris-assembly packages as the rest is already built in the image
colcon build --packages-select tetris-assembly_example_package
```