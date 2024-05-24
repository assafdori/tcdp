FROM python:3.9-slim

WORKDIR /app

COPY . .

RUN pip install --no-cache-dir -r requirements.txt

ENV FLASK_SERVER_PORT=9091

CMD ["python", "server.py"]
