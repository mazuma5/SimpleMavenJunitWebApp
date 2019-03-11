
FROM tomcat
WORKDIR /usr/local/tomcat/webapps/
RUN rm -f /usr/local/tomcat/work/Catlina/localhost/SimpleMavenJunitWebApp
ADD target/SimpleMavenJunitWebApp.war /usr/local/tomcat/webapps/
