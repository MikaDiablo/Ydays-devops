FROM python:latest

ADD hello_world.py /

RUN pip install flask

RUN python hello_world.py

EXPOSE 5000 





