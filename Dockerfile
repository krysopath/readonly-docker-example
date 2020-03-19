FROM alpine

COPY run.sh /bin/run.sh


### the following three lines are not necessary to run the setup
WORKDIR /volume
RUN chown -R 1337:1337 /volume
USER 1337:1337


CMD /bin/run.sh
