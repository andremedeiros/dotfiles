# colima (docker runtime) — point DOCKER_HOST at the colima socket so
# testcontainers and other socket-probing tools find it. The docker CLI
# itself uses the `colima` context, but testcontainers-go checks
# DOCKER_HOST / /var/run/docker.sock and doesn't read docker contexts.
# Guarded: an explicitly set DOCKER_HOST wins, and a stopped colima
# (dead socket) leaves it untouched.
if not set -q DOCKER_HOST; and test -S $HOME/.colima/default/docker.sock
    set -gx DOCKER_HOST "unix://$HOME/.colima/default/docker.sock"
end

# TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE is the socket path *inside* the
# colima VM that ryuk bind-mounts; the VM's docker socket is always
# /var/run/docker.sock. Without it, testcontainers mounts the macOS
# socket path into the reaper container, which fails with
# "mkdir ...: operation not supported".
if not set -q TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE; and string match -q '*colima*' -- $DOCKER_HOST
    set -gx TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE /var/run/docker.sock
end
