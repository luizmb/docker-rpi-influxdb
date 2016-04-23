FROM resin/rpi-raspbian:latest

RUN sudo apt-get update

RUN sudo apt-get install apt-utils ruby2.0 ruby2.0-dev gcc rubygems build-essential
RUN sudo gem install fpm
RUN gvm pkgset create influxdb
RUN gvm pkgset use influxdb
RUN mkdir -p ~/.gvm/pkgsets/go1.5/influxdb/src/github.com/influxdata
RUN cd ~/.gvm/pkgsets/go1.5/influxdb/src/github.com/influxdata
RUN git clone https://github.com/influxdata/influxdb.git
RUN cd influxdb
RUN ./package.sh -t deb -p 0.9.4
RUN sudo dpkg -i influxdb_0.9.4_armhf.deb

EXPOSE 8083 8086 8086/udp 8088 2003 4242 25826

WORKDIR /app
COPY influxd /app/
ENV PATH=/app:$PATH

RUN influxd config > /etc/influxdb.toml
RUN sed -i 's/dir = "\/.*influxdb/dir = "\/data/' /etc/influxdb.toml
VOLUME ["/data"]

ENTRYPOINT ["influxd", "--config", "/etc/influxdb.toml"]
