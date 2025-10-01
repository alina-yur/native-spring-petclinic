from locust import HttpUser, task
from locust.contrib.fasthttp import FastHttpUser

class PetClinicJVMUser(HttpUser):
    host = "http://localhost:8080"
    
    @task
    def home(self):
        self.client.get("/")
    
    @task
    def find_owners(self):
        self.client.get("/owners/find")
    
    @task
    def vets(self):
        self.client.get("/vets.html")