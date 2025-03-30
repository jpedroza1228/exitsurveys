# Use python as base image
FROM python:3.12-slim

WORKDIR /app

COPY package_requirements.txt package_requirements.txt

# Install dependencies
RUN pip install --no-cache-dir -r package_requirements.txt

# Copy the rest of the application code
COPY app.py app.py

# Expose the port Streamlit uses
EXPOSE 8501

# Command to run the app
CMD ["streamlit", "run", "app.py"]

# docker build -t exit-survey-app .
# docker run -p 8501:8501 exit-survey-app
# docker ps
# docker stop container id