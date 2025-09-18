set -x
wrk -s mixed-requests.lua --duration 10s --connections 1 --threads 1 http://localhost:8080
wrk -s mixed-requests.lua --duration 20s --connections 1 --threads 1 http://localhost:8080
