FROM elixir:1.12.1
 
ARG env=prod
 
ENV LANG=en_US.UTF-8 \
   TERM=xterm \
   MIX_ENV=$env
 
WORKDIR /opt/build
RUN mkdir -p /opt/build/bin/
ADD ./bin/build ./bin/build
 
CMD ["bin/build"]
