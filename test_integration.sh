#!/bin/bash

FRONTEND_URL="http://localhost:8080"
BACKEND_URL="http://localhost:3000/greet"

test_backend() {
    echo "Testing backend service..."
    
    # Make a request to the backend
    backend_response=$(curl -s -w "%{http_code}" -o /tmp/backend_response.json $BACKEND_URL)
    http_code=${backend_response: -3}

    # Check if backend is returning a successful response
    if [ "$http_code" -eq 200 ]; then
        message=$(jq -r '.message' /tmp/backend_response.json)
        if [ "$message" == "Hello from the Backend!" ]; then
            echo "Backend test passed! Message: $message"
        else
            echo "Backend test failed! Unexpected message: $message"
            exit 1
        fi
    else
        echo "Backend test failed! HTTP code: $http_code"
        exit 1
    fi
}

test_frontend() {
    echo "Testing frontend service..."

    # Make a request to the frontend
    frontend_response=$(curl -s -w "%{http_code}" -o /tmp/frontend_response.html $FRONTEND_URL)
    http_code=${frontend_response: -3}

    # Check if frontend is returning a successful response
    if [ "$http_code" -eq 200 ]; then
        # Check if the frontend response contains the correct message from the backend
        if grep -q "Hello from the Backend!" /tmp/frontend_response.html; then
            echo "Frontend test passed!"
        else
            echo "Frontend test failed! Unexpected response:"
            cat /tmp/frontend_response.html
            exit 1
        fi
    else
        echo "Frontend test failed! HTTP code: $http_code"
        exit 1
    fi
}

test_backend
test_frontend

echo "All tests passed successfully!"
