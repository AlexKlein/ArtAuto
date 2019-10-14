# Use an Oracle DB with Apex runtime as a parent image
FROM bakostamas/oracle-xe-11g-apex5

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Expose ports.
EXPOSE 1521
EXPOSE 8080
EXPOSE 49161