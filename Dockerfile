FROM 0x01be/base as build

WORKDIR /ocaml

ENV OCAML_REVISION=4.11.1 \
    OPAM_REVISION=master
ENV PATH=${PATH}:/opt/ocaml/bin/
RUN apk add --no-cache --virtual ocaml-build-dependencies \
    git \
    build-base \
    libx11-dev \
    libintl \
    wget \
    rsync \
    bubblewrap \
    bash &&\
    git clone --depth 1 --branch ${OCAML_REVISION} https://github.com/ocaml/ocaml.git /ocaml &&\
    ./configure -prefix=/opt/ocaml &&\
     make
RUN make install

WORKDIR /opam
RUN git clone --depth 1 --branch ${OPAM_REVISION} https://github.com/ocaml/opam.git /opam &&\
    ./configure -prefix=/opt/opam &&\
    make lib-ext &&\
    make
RUN make install

ENV PATH=${PATH}:/opt/opam/bin/

RUN opam init -y &&\
    opam install dune -y

