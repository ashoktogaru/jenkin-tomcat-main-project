# Download Base Image from hub.docker.com
FROM ubuntu

# Environment Variables
ENV TZ=Asia/Kolkata  

# Update Environment Variable unto File 
RUN echo $TZ > /etc/timezone 

# Download, Install & Configure 
RUN apt-get update 
RUN apt-get install openjdk-11-jdk -y 
RUN apt-get install wget -y 
RUN apt-get install curl -y 
RUN apt-get install unzip -y 
RUN apt-get install tree -y 
RUN apt-get install git -y 
RUN apt-get install vim -y 

# Environment Variables
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/

# Update Environment Variable unto File 
RUN echo $JAVA_HOME >> /etc/environment

# Cleanup APT Command 
RUN apt-get clean 

RUN mkdir /opt/tomcat/

WORKDIR /opt/tomcat
RUN curl -O https://downloads.apache.org/tomcat/tomcat-8/v8.5.84/bin/apache-tomcat-8.5.84.tar.gz
RUN tar xvfz apache*.tar.gz 
RUN mv apache-tomcat-8.5.84/* /opt/tomcat/.

COPY context.xml /opt/tomcat/webapps/manager/META-INF/
COPY context.xml /opt/tomcat/webapps/host-manager/META-INF/
COPY tomcat-users.xml /opt/tomcat/conf/
COPY tomcat.service /etc/systemd/system/tomcat.service
COPY devops.war /opt/tomcat/webapps/

# WORKDIR /opt/tomcat/webapps
WORKDIR /opt/tomcat/webapps/
#RUN curl -O -L https://github.com/kesavkummari/devops/blob/master/target/devops-1.0.0-SNAPSHOT.war

# Enable WebServer Port i.e. HTTP 80/TCP
EXPOSE 8080

# Execute WebServer
CMD ["/opt/tomcat/bin/catalina.sh", "run"]
