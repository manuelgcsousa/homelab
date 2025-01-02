FROM python:3

WORKDIR /app

COPY . /app

RUN pip install --no-cache-dir uv

EXPOSE 5000

CMD ["uv", "run", "main.py"]
