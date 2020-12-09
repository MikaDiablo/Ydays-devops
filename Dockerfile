FROM python:latest

ADD hello_world.py /

RUN pip install flask

CMD ["/hello_world.py"]

EXPOSE 5000 






