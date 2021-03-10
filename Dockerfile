FROM python:latest

# Copy local code to the container image.
ENV APP_HOME /app
WORKDIR $APP_HOME
COPY . ./

# Install production dependencies.
RUN pip install Flask gunicorn futures

# Run the web service on container startup. Here we use the gunicorn
CMD ["python", "app.py"]
