FROM ubuntu:latest AS build
WORKDIR /pvpgn
RUN apt-get update && apt-get -y install build-essential git cmake zlib1g-dev
RUN git clone https://github.com/pvpgn/pvpgn-server.git
RUN cd pvpgn-server && cmake -G "Unix Makefiles" -H./ -B./build
RUN cd pvpgn-server/build && make && make install
# Turn off tracking.
RUN sed -i 's/^track = 60/track = 0/' /usr/local/etc/pvpgn/bnetd.conf

FROM ubuntu:latest
COPY --from=build /usr/local /usr/local
EXPOSE 6112
CMD ["/usr/local/sbin/bnetd", "-f"]
