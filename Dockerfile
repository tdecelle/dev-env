FROM ubuntu:focal AS base
WORKDIR /usr/local/bin
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common curl git build-essential libfuse2 wget unzip && \
    apt-add-repository -y ppa:ansible/ansible && \
    apt-get update && \
    apt-get install -y curl git sudo ansible build-essential && \
    apt-get clean autoclean && \
    apt-get autoremove --yes

FROM base AS heretic
ARG TAGS
RUN addgroup --gid 1000 heretic
RUN (echo "heretic"; echo "heretic") | adduser --gecos heretic --uid 1000 -gid 1000 heretic && usermod -aG sudo heretic
USER heretic
ENV USER=heretic
WORKDIR /home/heretic/install

FROM heretic
COPY . .
CMD ["sh", "-c", "ansible-playbook $TAGS local.yml"]
