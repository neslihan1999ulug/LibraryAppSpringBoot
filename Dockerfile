FROM maven:3.9.3-eclipse-temurin-17 AS build

WORKDIR /app

COPY pom.xml .
COPY src ./src

RUN mvn clean package -Dmaven.test.skip=true

FROM eclipse-temurin:17-jdk

WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["sh", "-c", "java -Dspring.datasource.url=jdbc:postgresql://${DBURL}:${DBPORT}/${DBNAME} -Dspring.datasource.username=${DBUSERNAME} -Dspring.datasource.password=${DBPASSWORD} -Dspring.jpa.hibernate.ddl-auto=update -jar app.jar"]