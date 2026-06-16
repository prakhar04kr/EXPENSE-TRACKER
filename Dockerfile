# Production image for Spring Boot JSP app
FROM eclipse-temurin:17-jdk as builder
WORKDIR /app
COPY pom.xml /app/
COPY src /app/src
RUN mvn -q -DskipTests package

FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=builder /app/target/*.jar /app/app.jar
EXPOSE 8080
ENV SPRING_PROFILES_ACTIVE=prod
ENTRYPOINT ["java","-jar","/app/app.jar"]

