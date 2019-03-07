
FROM tomcat
WORKDIR /usr/local/tomcat/webapps/
ADD target/SimpleMavenJunitWebApp.war /usr/local/tomcat/webapps/
