# Docker NIST HL7v2 Syndromic Surveillance Test Suite Deployment Guide

## Table of Contents
- Introduction
- Installation
- Configuration
- Launching the Application
- User Registration
- Troubleshooting
- Additional Resources

## Introduction

This guide provides comprehensive instructions for deploying our application using Docker. The containerized approach ensures consistent deployment across different environments while minimizing configuration issues.

## Installation

### Step 1: Download Required Files

Download the following configuration files:
- `docker-compose.yml` - Contains the Docker container configuration
- `app-config.properties` - Contains application-specific settings

### Step 2: Create Project Directory

Create a dedicated directory for the application and place the downloaded files inside:

```bash
mkdir -p ~/docker-app
cd ~/docker-app
# Copy or move the downloaded files to this directory
```

### Step 3: Install Docker

If you don't have Docker installed on your system, follow the official installation guide:

1. Visit the Docker documentation: [https://docs.docker.com/engine/install/](https://docs.docker.com/engine/install/)
2. Select your operating system and follow the installation instructions
3. Verify installation by running:
   ```bash
   docker --version
   docker-compose --version
   ```

#### Docker Installation Quick Links:
- [Docker Desktop for Windows](https://docs.docker.com/desktop/install/windows-install/)
- [Docker Desktop for Mac](https://docs.docker.com/desktop/install/mac-install/)
- [Docker Engine for Ubuntu](https://docs.docker.com/engine/install/ubuntu/)
- [Docker Engine for Debian](https://docs.docker.com/engine/install/debian/)
- [Docker Engine for CentOS](https://docs.docker.com/engine/install/centos/)

## Configuration

### Configuring Application Settings

#### Selecting a version
By default, the docker compose file will use the latest version. To configure the version:
1. Open the `docker-compose.yml` file in a text editor
2. Locate the `ss2015-tomcat:image` property
3. Change the image link from `nist775hit/ss2015-tool:latest` to `nist775hit/ss2015-tool:TOOLVERSION`
4. Save the file


## Launching the Application

Once you've completed the configuration, follow these steps to launch the application:

1. Open a terminal or command prompt
2. Navigate to the directory containing your configuration files:
   ```bash
   cd ~/docker-app  # Or the path where you placed the files
   ```
3. Start the application using Docker Compose:
   ```bash
   docker compose up
   ```
   
   To run the application in the background (detached mode):
   ```bash
   docker compose up -d
   ```

4. Docker will download the necessary images (if not already present) and start the containers
5. Wait for the initialization process to complete

> **Note**: The first launch may take several minutes as Docker downloads the required images.

#### Optional: Custom MySQL Configuration

If you need to pass custom parameters to the MySQL server, you can create a `db_config` directory in your project root and place a `my-custom.cnf` file inside it. Docker Compose will mount this into the MySQL container’s `/etc/mysql/conf.d` so that your settings are applied on startup.

1. Create the `db_config` folder:

2. In db_config/my-custom.cnf, add any MySQL options you need:
   ```properties
   [mysqld]
   # Example custom parameters:
   max_allowed_packet=64M
   innodb_buffer_pool_size=1G
   ```
   
## User Registration

After the application is running, follow these steps to register an administrative user:

1. Open your web browser
2. Navigate to [http://localhost:8087/ss-r2](http://localhost:8087/ss-r2)
3. Click on the "Register" option
4. Enter your details, using the same email address configured in the `admin.emails` property
5. Complete the registration process

Once registered, you will have administrative privileges, allowing you to:
- Push and manage profiles
- Configure system settings
- Manage other users
- Access administrative features

## Troubleshooting

### Common Issues and Solutions

#### Application Not Accessible

If you cannot access the application at http://localhost:8889/ss-r2:

1. Verify that Docker containers are running:
   ```bash
   docker ps
   ```
2. Check container logs for errors:
   ```bash
   docker compose logs
   ```
3. Ensure no other application is using port 8889

#### Changing the Port

If port 8889 is already in use or you need to use a different port:

1. Open the `docker-compose.yml` file
2. Locate the port mapping section (typically formatted as `8087:8080`)
3. Change the first number to your desired port:
   ```yaml
   ports:
     - "13102:8080"  # This maps port 13102 on your host to 8080 in the container
   ```
4. Save the file and restart the application:
   ```bash
   docker compose down
   docker compose up -d
   ```

#### Administrator Email Not Working

If you're unable to gain administrative privileges:

1. Verify the email in `app-config.properties` matches exactly with the one used for registration
2. Check for typos or formatting issues in the configuration
3. Restart the application after making changes:
   ```bash
   docker compose restart
   ```

## Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Container Best Practices](https://docs.docker.com/develop/dev-best-practices/)

---
