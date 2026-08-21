# podman + testcontainers.
#
# testcontainers-go only treats the runtime as podman when DOCKER_HOST
# contains the literal substring "podman.sock" (provider.go); podman
# machine's stock symlink provides exactly such a path. Without this,
# testcontainers assumes real Docker and asks for the "bridge" network,
# which podman doesn't have — ryuk (the test-container reaper) then
# fails to start. An explicitly set DOCKER_HOST wins, and a stopped or
# absent podman machine (dead symlink) leaves it untouched.
if not set -q DOCKER_HOST; and test -S $HOME/.local/share/containers/podman/machine/podman.sock
    set -gx DOCKER_HOST "unix://$HOME/.local/share/containers/podman/machine/podman.sock"
end

# TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE is the socket path *inside* the
# podman VM that ryuk bind-mounts; the VM symlinks /var/run/docker.sock
# to its rootful podman socket. Guarded separately from DOCKER_HOST:
# without the override, testcontainers mounts the macOS socket path into
# the reaper container, which fails with "statfs ...: operation not
# supported" — this must apply even when DOCKER_HOST was set elsewhere.
if not set -q TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE; and string match -q '*podman*' -- $DOCKER_HOST
    set -gx TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE /var/run/docker.sock
end
