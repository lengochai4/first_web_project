# Giai đoạn 1: Build file .war bằng Maven
FROM maven:3.8.6-openjdk-11 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package

# Giai đoạn 2: Chạy ứng dụng trên Tomcat 9
FROM tomcat:9.0-jdk11-openjdk-slim
# Xóa ứng dụng mặc định của Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*
# Copy file war đã build vào làm ứng dụng mặc định (ROOT.war) để vào thẳng trang chủ
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]