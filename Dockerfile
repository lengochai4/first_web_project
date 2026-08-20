# Sử dụng Tomcat 9 với JDK 17
FROM tomcat:9.0-jdk17-temurin

WORKDIR /usr/local/tomcat

# 1. Xóa các webapp mặc định của Tomcat
RUN rm -rf webapps/*

# 2. Tạo thư mục ROOT và thư mục chứa code đã biên dịch
RUN mkdir -p webapps/ROOT/WEB-INF/classes

# 3. Copy toàn bộ file web (HTML, JSP, CSS, WEB-INF) vào ROOT
COPY src/main/webapp/ webapps/ROOT/

# 4. Copy toàn bộ code Java vào container để chuẩn bị dịch
COPY src/main/java /tmp/src

# 5. Tự động biên dịch toàn bộ file .java bằng javac (Dùng trực tiếp thư viện của Tomcat)
RUN find /tmp/src -name "*.java" > /tmp/sources.txt && \
    if [ -s /tmp/sources.txt ]; then \
        javac -cp "lib/*:webapps/ROOT/WEB-INF/lib/*" -d webapps/ROOT/WEB-INF/classes @/tmp/sources.txt; \
    fi && \
    rm -rf /tmp/src /tmp/sources.txt

EXPOSE 8080
CMD ["catalina.sh", "run"]