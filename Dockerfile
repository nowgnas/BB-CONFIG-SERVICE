FROM amazoncorretto:11-alpine AS builder

ENV USE_PROFILE local
ENV GITHUB_USERNAME username
ENV GITHUB_PERSONAL_ACCESS_TOKEN token
ENV ENCRYPT_SECRET_KEY secret

COPY gradlew .
COPY gradle gradle
COPY build.gradle .
COPY settings.gradle .
COPY src src
RUN chmod +x ./gradlew
RUN ./gradlew clean bootJar

FROM amazoncorretto:11-alpine
COPY --from=builder build/libs/*.jar app.jar

ENTRYPOINT ["java", "-jar", \
            "-Dspring.profiles.active=${USE_PROFILE}", \
            "-Dgithub.username=${GITHUB_USERNAME}", \
            "-Dgithub.token=${GITHUB_PERSONAL_ACCESS_TOKEN}", \
            "-Dsecret=${ENCRYPT_SECRET_KEY}", \
            "/app.jar"]
