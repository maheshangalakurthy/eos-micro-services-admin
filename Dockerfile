FROM openjdk:11
LABEL "NAME"="Mahesh Babu" "EMAIL"="maheshchowdary595@gmail.com"
ADD target/ether-0.0.1-RELEASE.jar ether.jar
CMD ["java","-jar","ether.jar"]
