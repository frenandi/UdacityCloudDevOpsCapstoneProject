FROM python:3

# Adding working directory
WORKDIR /app

# Copying the code to working directory
COPY . app.py /app/

# Installing packages
RUN pip install --upgrade pip==20.2.2 &&\
    pip install --trusted-host pypi.python.org -r requirements.txt

# Exposing the port 80
EXPOSE  80 

# Run app.py at container launch
CMD [ "python", "app.py" ]