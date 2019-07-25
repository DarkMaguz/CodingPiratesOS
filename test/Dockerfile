# Base the image off of Python 3.7.
FROM python:3.7

# Getting the prerequisite packages.
ADD requirements.txt /requirements.txt
RUN pip install --no-cache-dir -r /requirements.txt

# Make the base directory for our application.
RUN mkdir -p /usr/app

# Set our working directory.
WORKDIR /usr/app

CMD ["python", "main.py"]
