FROM eclipse-temurin:21-jdk-bookworm

ENV DEBIAN_FRONTEND=noninteractive \
    MAVEN_VERSION=3.9.9 \
    GRADLE_VERSION=8.12.1 \
    MAVEN_HOME=/opt/maven \
    GRADLE_HOME=/opt/gradle

RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl wget vim make unzip \
    && rm -rf /var/lib/apt/lists/*

# --- Maven ---
RUN curl -fsSL \
    https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    | tar -xz -C /opt && \
    mv /opt/apache-maven-${MAVEN_VERSION} /opt/maven
ENV PATH="${MAVEN_HOME}/bin:${PATH}"

# --- Gradle ---
RUN curl -fsSL \
    https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip \
    -o /tmp/gradle.zip && \
    unzip -q /tmp/gradle.zip -d /opt && \
    mv /opt/gradle-${GRADLE_VERSION} /opt/gradle && \
    rm /tmp/gradle.zip
ENV PATH="${GRADLE_HOME}/bin:${PATH}"

# --- Pre-warm Gradle daemon and Maven local repo (speeds up first project build) ---
RUN gradle --version && mvn --version

WORKDIR /workspace

EXPOSE 8080

CMD ["/bin/bash"]
