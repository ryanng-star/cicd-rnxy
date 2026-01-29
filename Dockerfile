# 1. Use a lightweight Python base image
FROM python:3.9-slim

# 2. Set the working directory inside the container
WORKDIR /app

# 3. Copy all your files (main.py, requirements.txt) into the container
COPY . .

# 4. Install the Flask library
RUN pip install -r requirements.txt

# 5. Tell the container to start your app when it loads
CMD ["python", "main.py"]