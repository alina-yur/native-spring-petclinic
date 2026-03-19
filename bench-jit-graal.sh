set -e

function print() {
    printf "\033[1;34m$1\033[0m\n"
}

print "Starting java -Xmx512m -jar ./target/spring-petclinic-4.0.0-SNAPSHOT.jar"

java -Xmx512m -jar ./target/spring-petclinic-4.0.0-SNAPSHOT.jar &
export PID=$!
sleep 5
print "Done waiting for Spring Petclinic to come up..."

print "Warming up Spring Petclinic..."
wrk -s mixed-requests.lua --duration 10s --connections 1 --threads 1 http://localhost:8080
print "Exercising Spring Petclinic..."
wrk -s mixed-requests.lua --duration 20s --connections 1 --threads 1 http://localhost:8080

print "Done!"
kill $PID
sleep 1
