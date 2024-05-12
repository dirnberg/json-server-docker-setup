# Setting Up and Monitoring a REST API Using json-server on Windows 11

## Introduction

This detailed guide explains how to set up a REST API using json-server within a Docker container on Windows 11 and monitor network traffic with Wireshark. It also includes best practices for interacting with the API using `curl` commands, emphasizing common pitfalls and how to avoid them.

## Tools Used

- **Windows 11 (Version 22H2)**
- **Docker version 26.0.0, build 2ae903e**
- **Wireshark version 4.2.4**
- **json-server**
- **`curl` for Windows**

This documentation is inspired and guided by the foundational resources available at [DevOps Cell](https://devopscell.com/api/rest/json/nodejs/docker/2017/09/27/api-rest-json-server-nodejs-docker.html).

## Step-by-Step Setup

### Step 1: Configure Your Working Environment

#### Create a Project Directory 
1. **Open Command Prompt as Administrator**:
   - Search for "cmd" in the Start menu, right-click on Command Prompt, and select "Run as administrator".

2. **Navigate to Your Desktop (for Excample) and Create a Directory**:
   ```cmd
   cd %USERPROFILE%\Desktop
   mkdir jsonserver
   cd jsonserver
   ```

### Step 2: Create and Configure Dockerfile

1. **Create a Dockerfile**:
   - Ensure that the file is named `Dockerfile` and not `Dockerfile.txt`. A common error is saving the file with a `.txt` extension, which Docker will not recognize.
   - Use a text editor to create a Dockerfile with the following contents:

   ```Dockerfile
   FROM node:latest
   WORKDIR /app
   RUN npm install -g json-server
   RUN echo '{"cars":[{"id":1,"brand":"opel","model":"corsa"},{"id":2,"brand":"ford","model":"fiesta"}]}' > /app/db.json
   EXPOSE 8080
   CMD ["json-server", "--watch", "/app/db.json", "--port", "8080", "--host", "0.0.0.0"]
   ```

2. **Build the Docker Image**:
   - Execute the following command to build the Docker image:
     ```cmd
     docker build -t jsonserver .
     ```

3. **Run the Docker Container**:
   - Start the json-server with this command:
     ```cmd
     docker run --rm -it --name jsonserver-container -p 8080:8080 jsonserver
     ```

### Step 3: Monitor API Traffic with Wireshark

1. **Open Wireshark**:
   - Launch Wireshark and select the Loopback interface for capturing traffic. This interface will capture all local traffic between your machine and the json-server.

2. **Apply the Filter**:
   - Set the display filter to `tcp.port == 8080` to focus on the API traffic:
     ```wireshark
     tcp.port == 8080
     ```

3. **Start the Capture**:
   - Begin capturing data before initiating any API requests to ensure all traffic is logged.

4. **Analyze Traffic**:
   - Use the `Follow` > `HTTP Stream` function on relevant packets to view detailed HTTP communication.

### Step 4: Interact with the API Using Curl

Each `curl` command is presented in its own box for clarity, with a comment explaining its purpose.

#### Retrieve All Entries (GET)
```cmd
# Fetch all car entries from the API
curl -v http://localhost:8080/cars
```

#### Create a New Entry (POST)
```cmd
# Create a new car entry in the database
curl -v -i -H "Accept: application/json" -H "Content-Type: application/json" -X POST -d "{\"brand\":\"Volkswagen\",\"model\":\"Golf\"}" http://localhost:8080/cars
```

#### Update an Existing Entry by ID (PUT)
```cmd
# Update an existing car entry by ID
curl -v -H "Accept: application/json" -H "Content-Type: application/json" -X PUT -d "{\"brand\":\"Audi\",\"model\":\"A4\"}" http://localhost:8080/cars/1
```

#### Delete an Entry by ID (DELETE)
```cmd
# Remove a car entry by ID
curl -v -X DELETE http://localhost:8080/cars/1
```

#### Advanced Queries Using Verbose Mode
```cmd
# Sort entries by model; not using "asc" as it is default and implicit
curl -v "http://localhost:8080/cars?_sort=model"
```

### Common Pitfalls and Solutions

1. **Dockerfile Naming**: Ensure the Dockerfile is named correctly without any extension like `.txt`. Incorrect file naming will prevent Docker from recognizing and using the file.

2. **Using Curl in Command Prompt**: It’s essential to run `curl` commands in Command Prompt and not in PowerShell, as PowerShell handles quotation marks differently, which can cause errors in the commands.

3. **Accessing the Server**: Always use `http://localhost:8080` to access your server. Trying to access it via `http://0.0.0.0:8080` can lead to issues, especially on Windows systems where `0.0.0.0` may not be interpreted correctly as localhost.

### Conclusion

This guide offers a thorough overview of setting up, monitoring, and interacting with a REST API using modern tools and best practices. The details provided ensure that even those new to such setups can proceed with confidence and avoid common errors.

If there are any further questions or additional assistance is needed, please feel free to reach out.

Documenation was written with help of ChatGPT 4.