FROM alpine

COPY run.sh /bin/run.sh

WORKDIR /volume
RUN chown -R 1337:1337 /volume
USER 1337:1337


CMD /bin/run.sh
