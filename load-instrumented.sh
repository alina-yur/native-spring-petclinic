set -e

function print() {
    printf "\033[1;35m$1\033[0m\n"
}

print "Starting instrumented Spring Petclinic..."
./target/spring-petclinic-instrumented -Xmx512m &
export PID=$!
psrecord $PID --plot "$(date +%s)-native.png" --max-cpu 1600 --max-memory 800 --include-children &

sleep 3
print "Done waiting for Spring Petclinic to come up..."

print "Warming up Spring Petclinic..."
wrk -s mixed-requests.lua --duration 10s --connections 1 --threads 1 http://localhost:8080
print "Exercising Spring Petclinic..."
wrk -s mixed-requests.lua --duration 20s --connections 1 --threads 1 http://localhost:8080

print "Done!"
kill $PID
sleep 1
