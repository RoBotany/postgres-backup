FROM alpine:3.9

ENV PGHOST='localhost'
ENV PGHOST='5432'
ENV PGDATABASE='postgres'
ENV PGUSER='postgres'
ENV PGPASSWORD='password'

RUN apk update
RUN apk add postgresql

COPY dumpDatabase.sh .

ENTRYPOINT [ "/bin/sh" ]
CMD [ "./dumpDatabase.sh" ]
