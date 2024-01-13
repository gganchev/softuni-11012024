FROM golang
RUN apt-get update && apt-get install -y git dos2unix && apt-get clean
WORKDIR /usr/src/app
# first build the mkcert app
RUN git clone https://github.com/FiloSottile/mkcert
WORKDIR /usr/src/app/mkcert/
RUN go build -ldflags "-X main.Version=$(git describe --tags)"
RUN chmod a+x mkcert && mkdir output
COPY ./entrypoint.sh /usr/src/app/
RUN dos2unix /usr/src/app/entrypoint.sh && chmod a+x /usr/src/app/entrypoint.sh
ENTRYPOINT ["/usr/src/app/entrypoint.sh"]