FROM python:3.8
 
RUN pip install flask
 
COPY . /app
 
WORKDIR /app
 
EXPOSE 8080
 
CMD ["python", "helloworld.py"]
