#
# Build stage
#
FROM maven:3.8.5-openjdk-17-slim AS maven
WORKDIR /bookmark-backend/
COPY /bookmark-backend .
RUN mvn clean package -DskipTests
#
# Package stage
#
FROM openjdk:17-slim
COPY --from=maven bookmark-backend/target/*.jar /app.jar
ENTRYPOINT ["java","-jar","/app.jar"]
