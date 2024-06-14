FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt /app/

COPY joke.py /app/

RUN pip3 install --no-cache-dir -r requirements.txt

EXPOSE 5050

CMD ["python3", "joke.py"]

