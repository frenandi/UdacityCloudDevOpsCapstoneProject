from flask import Flask
app = Flask(__name__)

@app.route("/")
def hello_www():
    return "Hola pequeno Coquin =0p"

if __name__ == '__main__':
      app.run(host='0.0.0.0', port=80)