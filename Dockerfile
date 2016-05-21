FROM resin/rpi-raspbian:latest

RUN sudo apt-get update
RUN sudo apt-get install -y apt-utils curl git subversion wget
#  gcc build-essential

RUN wget --no-check-certificate https://dl.influxdata.com/influxdb/releases/influxdb_0.13.0_armhf.deb
RUN sudo dpkg -i influxdb_0.13.0_armhf.deb

EXPOSE 8083 8086 8086/udp 8088 2003 4242 25826

RUN influxd config > /etc/influxdb.toml
RUN sed -i 's/dir = "\/.*influxdb/dir = "\/data/' /etc/influxdb.toml
VOLUME ["/data"]

ENTRYPOINT ["influxd", "--config", "/etc/influxdb.toml"]
