FROM	archlinux:latest as base

# Update mirrorlist
RUN sed -i '1s/^/##Bangladesh\nServer = http:\/\/mirror.xeonbd.com\/archlinux\/\$repo\/os\/\$arch \n\n/' /etc/pacman.d/mirrorlist
RUN	pacman --noconfirm -Suy
RUN pacman --noconfirm -Syu base base-devel ansible vi sudo curl git cmake
RUN pacman-key --init


FROM base as amahmod
ARG TAGS

RUN groupadd --gid 1000 amahmod  \
  && useradd -r -g amahmod -G wheel,audio,video,storage,optical amahmod \
  && mkdir -p /home/amahmod && chown -R amahmod:amahmod /home/amahmod  \
  && pacman --noconfirm -Syu  \
  && echo amahmod ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/amahmod  \
  && chmod 0440 /etc/sudoers.d/amahmod

USER amahmod
WORKDIR /home/amahmod

FROM amahmod
COPY . ./ansible
CMD ["sh", "-c", "ansible-playbook $TAGS local.yml"]
