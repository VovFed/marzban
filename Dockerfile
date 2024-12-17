FROM python:3.10-slim

ENV PYTHONUNBUFFERED=1

WORKDIR /code

RUN apt-get update \
    && apt-get install -y curl unzip gcc python3-dev dos2unix \
    && rm -rf /var/lib/apt/lists/*

RUN bash -c "$(curl -L https://raw.githubusercontent.com/VovFed/marzban/refs/heads/main/install_latest_xray.sh)"

COPY ./requirements.txt /code/
RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt

COPY . /code
RUN dos2unix /code/marzban-cli.py
RUN dos2unix /code/main.py

COPY ./.env /code/

RUN apt-get remove -y curl unzip gcc python3-dev

RUN ln -s /code/marzban-cli.py /usr/bin/marzban-cli \
    && chmod +x /usr/bin/marzban-cli \
    && marzban-cli completion install --shell bash



CMD ["bash", "-c", "alembic upgrade head; python main.py"]



