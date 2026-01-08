# ===== Build stage =====
FROM maven:3.9.9-eclipse-temurin-17 AS build

WORKDIR /app

# Copier le pom pour le cache Docker
COPY devops-app/pom.xml devops-app/pom.xml

# Télécharger les dépendances (cache efficace)
WORKDIR /app/devops-app
RUN mvn -B dependency:go-offline

# Copier le code source
COPY bonjour-devops/src src

# Build Maven
RUN mvn -B clean package

# ===== Runtime stage =====
FROM eclipse-temurin:17-jre

WORKDIR /app

# Copier le jar depuis l’étape build
COPY --from=build /app/devops-app/target/*jar app.jar

# Lancer l'application
CMD ["java", "-jar", "app.jar"]
