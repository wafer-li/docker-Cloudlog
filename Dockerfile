FROM ghcr.io/wavelog/wavelog:latest

# Add start script
COPY docker/start*.sh /
RUN chmod +x /start*.sh

# Expose ports.
EXPOSE 80
