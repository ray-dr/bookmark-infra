#
# Build stage
#
FROM maven:3.8.5-openjdk-17-slim AS maven
WORKDIR /usr/app
COPY /bookmark-backend .
RUN mvn clean package -DskipTests

#
# Package stage
#
FROM openjdk:17-slim
RUN pwd
RUN ls -al
COPY --from=maven usr/app/target/*.jar /app.jar
ENTRYPOINT ["java","-jar","/app.jar"]