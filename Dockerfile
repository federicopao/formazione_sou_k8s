FROM --platform=$BUILDPLATFORM python:3.8-slim-buster

WORKDIR /app
#install flask
RUN pip3 install flask
#copy app.py in the docker image
COPY ./app.py /app
#run app.py
ENTRYPOINT ["python3"]
CMD ["app.py"]
