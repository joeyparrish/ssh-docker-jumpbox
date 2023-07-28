FROM debian:trixie-slim

MAINTAINER Joey Parrish

ENV DEBIAN_FRONTEND=noninteractive

# Update packages and install sshd.
RUN apt-get -q update
RUN apt-get install -y --no-install-recommends openssh-server
RUN mkdir /var/run/sshd

# Clean up after apt to slim down the image.
RUN apt-get clean autoclean && \
    apt-get autoremove --yes && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/

# Only keys can be used to authenticate.
RUN echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
# No user-specific key files are checked.
RUN echo "AuthorizedKeysFile none" >> /etc/ssh/sshd_config
# Instead, we call this script to check user authentication.  It only
# recognizes one user, and one key, both of which are specified through docker
# environment variables.
RUN echo "AuthorizedKeysCommand /ssh-user-auth.sh" >> /etc/ssh/sshd_config
RUN echo "AuthorizedKeysCommandUser nobody" >> /etc/ssh/sshd_config
# The user is allowed to set up tunnels.
RUN echo "GatewayPorts yes" >> /etc/ssh/sshd_config

# Install our custom scripts.
COPY ssh-user-auth.sh /ssh-user-auth.sh
COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /ssh-user-auth.sh /entrypoint.sh

EXPOSE 22

ENTRYPOINT ["/entrypoint.sh"]
