#!/bin/bash

domain_name=$1
# Ако не е подаден домейн - изход + грешка
if [ ! $domain_name ]
then
  echo "No domain name supplied"
  exit 1
fi

# използваме папка в контейнера, в която да създадем сертификати
mkcert_path="/usr/src/app/mkcert/"
output_folder="${mkcert_path}output/"
certificates_folder="${mkcert_path}certs/"
mkdir -p "${certificates_folder}"

key_file_name="${certificates_folder}${domain_name}.key"
cert_file_name="${certificates_folder}${domain_name}.crt"

# създаване на сертификат, ключ, chain and chain key
CAROOT="${certificates_folder}" ./mkcert -key-file "${key_file_name}" -cert-file "${cert_file_name}" "${domain_name}"

# има ли генериран chain?
if [ ! -f "${certificates_folder}rootCA.pem" ]
then
  echo "No rootCA. Exiting."
  exit 2
fi
# Преместваме в поисканата папка с ново име
mv "${certificates_folder}rootCA.pem" "${output_folder}/${domain_name}.chain.pem"

# има ли генериран chain-key?
if [ ! -f "${certificates_folder}rootCA-key.pem" ]
then
  echo "No rootCA-key. Exiting."
  exit 3
fi
# Преместваме в поисканата папка с ново име
mv "${certificates_folder}rootCA-key.pem" "${output_folder}${domain_name}.chain.key"

# копираме сертификата и ключа му
cp "${certificates_folder}"* "${output_folder}/"


