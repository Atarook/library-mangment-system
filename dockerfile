# Use the official Python image as the base image
FROM python:3.10-slim

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file and install dependencies
COPY . /app
RUN pip install --no-cache-dir -r requirements.txt


# Expose the port on which the app will run
EXPOSE 8080

ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_RUN_PORT=8080

# Define the default command to run when the container starts
CMD ["python", "app.py"]
