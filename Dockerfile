FROM gliderlabs/alpine:3.4
RUN apk add --update \
    python \
    python-dev \
    musl-dev \
    libffi-dev \
    bash \
    openssl \
    openssl-dev \
    ca-certificates \
    linux-headers \
    gcc \
    py-pip && mkdir -p /code
ADD requirements.txt /code
RUN pip install -r /code/requirements.txt
WORKDIR /code
