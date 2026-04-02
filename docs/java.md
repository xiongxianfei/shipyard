# Java Development Environment

## Tools

| Tool | Version | Purpose |
|------|---------|---------|
| Eclipse Temurin JDK | 21 (LTS) | Java runtime and compiler |
| Maven | 3.9.9 | Build automation and dependency management |
| Gradle | 8.12.1 | Build automation (Kotlin/Groovy DSL) |

## Quick start

```bash
make java
# or: docker compose run --rm java
```

## Common workflows

### Create a Maven project

```bash
# Inside the container
mvn archetype:generate \
  -DgroupId=com.example \
  -DartifactId=my-app \
  -DarchetypeArtifactId=maven-archetype-quickstart \
  -DinteractiveMode=false

cd my-app
mvn package
java -cp target/my-app-1.0-SNAPSHOT.jar com.example.App
```

### Create a Gradle project

```bash
mkdir my-gradle-app && cd my-gradle-app
gradle init --type java-application --dsl kotlin
gradle run
gradle test
gradle build
```

### Spring Boot project

Generate a project at [start.spring.io](https://start.spring.io), download the zip,
extract it into `java/workspace/`, then:

```bash
# Maven
./mvnw spring-boot:run

# Gradle
./gradlew bootRun
```

The container exposes **port 8080** — add `-p 8080:8080` when running with `docker run`,
or use the `docker-compose.yml` service which already maps it.

### Useful Maven commands

```bash
mvn compile          # compile sources
mvn test             # run tests
mvn package          # build JAR/WAR
mvn dependency:tree  # show dependency tree
mvn versions:display-dependency-updates  # check for outdated deps
```

### Useful Gradle commands

```bash
gradle tasks         # list available tasks
gradle dependencies  # show dependency tree
gradle test          # run tests
gradle build         # full build (compile + test + assemble)
gradle clean build   # clean then build
```

## Tips

- Maven's local repository (`.m2/`) is inside the container and lost on `--rm`.
  Mount it as a volume to persist it across sessions:
  ```bash
  docker run -it --rm \
    -v $(pwd):/workspace \
    -v $HOME/.m2:/root/.m2 \
    ghcr.io/xiongxianfei/dev-java:latest
  ```
- For Gradle, add a named volume for `~/.gradle` similarly to avoid re-downloading
  the wrapper and dependencies on each run.
