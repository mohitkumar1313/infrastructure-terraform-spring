# Stage 1: Build the application using Maven
FROM maven:3.8.5-openjdk-17 AS build

# Set the working directory in the container
WORKDIR /app

# Copy the Maven project files to the container
COPY pom.xml .
COPY src ./src

# Package the application using Maven (skipping tests to speed up the build)
RUN mvn clean package -DskipTests

# Stage 2: Create the final image from OpenJDK
FROM openjdk:17-jdk-alpine

# Set the working directory in the container
WORKDIR /app

# Copy the JAR file from the build stage to the final image
COPY --from=build /app/target/spring-boot-example-0.0.1-SNAPSHOT.jar /app/scale-spring-app.jar

# Expose the port the application runs on
EXPOSE 8081

# Command to run the application
ENTRYPOINT ["java", "-jar", "/app/scale-spring-app.jar"]
