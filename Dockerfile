FROM ubuntu:22.04 AS base
WORKDIR /usr/local/bin
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common curl git build-essential && \
    apt-add-repository -y ppa:ansible/ansible && \
    apt-get update && \
    apt-get install -y curl git ansible build-essential sudo && \
    apt-get clean autoclean && \
    apt-get autoremove --yes

FROM base AS primary
ARG TAGS
RUN addgroup --gid 1000 amahmod
RUN adduser --gecos amahmod --uid 1000 --gid 1000 --disabled-password amahmod \
    && echo amahmod ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/amahmod  \
    && chmod 0440 /etc/sudoers.d/amahmod \
    && mkdir -p /home/amahmod && chown -R amahmod:amahmod /home/amahmod

WORKDIR /home/amahmod

FROM primary
COPY . .
USER root
RUN chown -R amahmod:amahmod /home/amahmod/.keys

USER amahmod
CMD ["sh", "-c", "ansible-playbook $TAGS local.yml"]
