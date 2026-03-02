# Stage 1: Build the application
FROM maven:3.9.6-eclipse-temurin-17-focal AS builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn -B package -DskipTests

# Stage 2: Create the final, smaller image
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Create a non-root user and group
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

COPY --from=builder /app/target/*.jar app.jar

# Set ownership to the new user
RUN chown appuser:appgroup app.jar

# Switch to the non-root user
USER appuser

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
