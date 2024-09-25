FROM openjdk:17-jdk-slim AS builder

# Copy and build your Spring Boot application
COPY target/spring-boot-demo-1.0.0.jar app.jar

# Install Filebeat
RUN apt-get update && \
    apt-get install -y wget && \
    wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-8.5.0-amd64.deb && \
    dpkg -i filebeat-8.5.0-amd64.deb && \
    rm filebeat-8.5.0-amd64.deb && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy the Filebeat configuration
COPY src/main/resources/filebeat.yml /etc/filebeat/filebeat.yml

# Start the Spring Boot application and Filebeat
CMD ["sh", "-c", "filebeat -e -c /etc/filebeat/filebeat.yml & java -jar /app.jar"]
