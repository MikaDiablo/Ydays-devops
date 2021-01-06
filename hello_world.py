from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'HELLO WORLD! FROM DEVOPS TEAM !'

if __name__ == '__main__':
    app.run()
