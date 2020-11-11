FROM ubuntu:16.04

USER root

#Adding heartbeat user
RUN groupadd -g 1000 heartbeat && \
    useradd -g 1000 -l -m -s /bin/bash -u 1000 heartbeat

WORKDIR /home/heartbeat

#Installing the Java Dependencies
RUN apt-get update && apt-get -y install software-properties-common curl

#Installing the Java jdk version 8
RUN add-apt-repository -y \
    ppa:webupd8team/java && \
    apt-get update && \
    apt-get install -y openjdk-8-jdk && \
    apt-get install -y ant && \
    apt-get clean;
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/

#Downloading the package
RUN curl https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-7.9.3-linux-x86_64.tar.gz -o heartbeat.tar.gz && \
    tar -xvf heartbeat.tar.gz --strip-components=1 && rm -rf heartbeat.tar.gz && ln -s /home/heartbeat/heartbeat /usr/local/bin/

COPY entrypoint.sh /home/heartbeat/

RUN chown -R heartbeat:heartbeat /home/heartbeat/* && chmod +x /home/heartbeat/entrypoint.sh

USER heartbeat

#CMD ["/bin/bash","-c", "./heartbeat -e"]
CMD ["/bin/bash","-c", "./entrypoint.sh"]
