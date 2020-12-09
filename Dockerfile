FROM python:latest

ADD hello_world.py /

EXPOSE 5000 

RUN pip install flask




