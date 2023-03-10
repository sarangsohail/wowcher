FROM openjdk:8-jre-alpine
COPY target/test.jar /app/
EXPOSE 8080
CMD ["java", "-jar", "/app/test.jar"]
