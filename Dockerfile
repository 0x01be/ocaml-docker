FROM 0x01be/ocaml:build as build

FROM 0x01be/base

COPY --from=build /opt/ /opt/
COPY --from=build /root/.opam/ /root/.opam/

RUN apk add --no-cache --virtual ocaml-runtime-dependencies \
    libstdc++

ENV PATH=${PATH}:/opt/ocaml/bin/:/opt/opam/bin/:/root/.opam/default/bin/

