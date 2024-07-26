FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

COPY . .

ENV DB_HOST=mysql
ENV DB_USER=root
ENV DB_PASSWORD=password

CMD ["python", "app.py"]
