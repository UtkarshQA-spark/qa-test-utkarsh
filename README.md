# QA Test Network Setup and Automated Test Execution

This document outlines the steps to set up a network, build and run backend and frontend services, and execute the provided automated test script.

## Prerequisites
- Docker installed on your system
- `curl` (used in the test script)
- `jq` (for JSON parsing in shell script)

## Steps

### 1. Create a Docker Network
A dedicated Docker network is created to facilitate communication between the backend and frontend services.

**Command:**
```
docker network create qa-test-network
```

### 2. Build backend-image on docker
```
docker build -t backend-image ./backend
```
##### output(short)
```
[+] Building 142.9s (9/9) FINISHED                                                                                            docker:desktop-linux
 => [internal] load build definition from Dockerfile                                                                                          0.0s
 => => writing image sha256:26461e180c2a72ca73a993645968b5c6f859306cc4101d0f28e3cf6717c7f2e0                                                  0.0s
 => => naming to docker.io/library/backend-image 
```

### 3. Build frontend-image on docker
```
docker build -t frontend-image ./frontend
```
##### output
```
[+] Building 5.1s (9/9) FINISHED                                                                                              docker:desktop-linux
 => [internal] load build definition from Dockerfile                                                                                          0.0s
 => => transferring dockerfile: 427B 
 => => writing image sha256:4aad90f33ba5065fb3f19934da29beabd1612025c0ce740f503ab418c0377ff8                                                  0.0s
 => => naming to docker.io/library/frontend-image  
```
### 4. Run backend-service on port 3000 with created network
```
docker run -d --name backend-service --network qa-test-network -p 3000:3000 backend-image
```
### 5. Run frontend-service on port 8080 with created network
```
docker run -d --name frontend-service --network qa-test-network -p 8080:8080 frontend-image
```
### 6. Make test script executable
```
chmod +x test_integration.sh
```
### 7. Execute test script
```
./test_integration.sh
```
##### output
```
Testing backend service...
Backend test passed! Message: Hello from the Backend!
Testing frontend service...
Frontend test passed!
All tests passed successfully!
```
