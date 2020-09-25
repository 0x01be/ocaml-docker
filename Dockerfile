FROM alpine as build

RUN apk add --no-cache --virtual ocaml-build-dependencies \
    git \
    build-base \
    libx11-dev \
    libintl \
    wget \
    rsync \
    bubblewrap \
    bash

ENV OCAML_REVISION 4.11.1
RUN git clone --depth 1 --branch ${OCAML_REVISION} https://github.com/ocaml/ocaml.git /ocaml

WORKDIR /ocaml

RUN ./configure -prefix=/opt/ocaml
RUN make
RUN make install

ENV OPAM_REVISION master
RUN git clone --depth 1 --branch ${OPAM_REVISION} https://github.com/ocaml/opam.git /opam

ENV PATH $PATH:/opt/ocaml/bin/

WORKDIR /opam
RUN ./configure -prefix=/opt/opam
RUN make lib-ext
RUN make
RUN make install

ENV PATH $PATH:/opt/opam/bin/

RUN opam init -y
RUN opam install dune -y

