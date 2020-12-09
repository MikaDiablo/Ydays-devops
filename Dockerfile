FROM python:latest

ADD hello_world.py /

RUN pip install flask

EXPOSE 5000 






