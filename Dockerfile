# Giai đoạn 1: Build file .war bằng Maven với JDK 17
FROM maven:3.8.6-eclipse-temurin-17 AS build
WORKDIR /app

# Copy file cấu hình và mã nguồn
COPY pom.xml .
COPY src ./src

# Build đóng gói ứng dụng (bỏ qua chạy test để build nhanh và tránh lỗi)
RUN mvn clean package -DskipTests

# Giai đoạn 2: Khởi chạy trên Tomcat 9 với JDK 17
FROM tomcat:9.0-jdk17-temurin
# Xóa các webapp mặc định của Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*
# Copy file war vừa build xong thành ROOT.war để làm trang chủ mặc định
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]