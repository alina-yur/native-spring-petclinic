set -e

function print() {
    printf "\033[1;35m$1\033[0m\n"
}

function print_rss() {
    local label="$1"
    local rss_mb
    rss_mb=$(ps -o rss= -p "$PID" | awk '{ printf "%.1f", $1 / 1024 }')
    print "$label RSS: ${rss_mb} MB"
}

APP="./target/spring-petclinic-ml-pgo"

print "Starting $APP"
"$APP" -Xmx512m &
export PID=$!
trap 'kill "$PID" 2>/dev/null || true; wait "$PID" 2>/dev/null || true' EXIT
sleep 1
print "Done waiting for Spring Petclinic to come up..."

print "Warming up Spring Petclinic..."
wrk -s mixed-requests.lua --duration 10s --connections 1 --threads 1 http://localhost:8080

print "Exercising Spring Petclinic..."
wrk -s mixed-requests.lua --duration 20s --connections 1 --threads 1 http://localhost:8080
print_rss "Final"

print "Done!"
