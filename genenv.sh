#!/bin/bash

ENV_FILE=".env"

if [ -f "$ENV_FILE" ]; then
    echo "Exiting: $ENV_FILE already exists:"
    cat $ENV_FILE
    exit 1
else
    echo "Generating $ENV_FILE with secrets..."
fi

generate_rand4() {
    openssl rand -base64 32 | tr -dc 'a-z0-9' | head -c 4
}

generate_secret() {
    openssl rand -base64 32 | tr -d '/+' | cut -c1-32
}

echo "COMPOSE_PROJECT_NAME=dingolytics-$(generate_rand4)" >> ${ENV_FILE}

echo "Application server tag: 0.1.3"
echo "APPLICATION_SERVER_TAG=0.1.3" >> ${ENV_FILE}

echo "Application front-end tag: 0.1.0"
echo "APPLICATION_FRONTEND_TAG=0.1.0" >> ${ENV_FILE}

WEB_HOST=:8100
echo "Local web host (customize it): ${WEB_HOST}"
echo "WEB_HOST=${WEB_HOST}" >> ${ENV_FILE}

WEB_HOST_LETSENCRYPT_EMAIL=internal
echo "Email for Let's Encrypt (customize it): ${WEB_HOST_LETSENCRYPT_EMAIL}"
echo "WEB_HOST_LETSENCRYPT_EMAIL=${WEB_HOST_LETSENCRYPT_EMAIL}" >> ${ENV_FILE}

VECTOR_INGEST_URL="[HOST]"
echo "Vector ingest host (customize it): ${VECTOR_INGEST_URL}"
echo "VECTOR_INGEST_URL=[HOST]" >> ${ENV_FILE}

echo "Adding secrets to ${ENV_FILE}..."
{
    echo "# Secrets:"
    echo "POSTGRES_PASSWORD=$(generate_secret)"
    echo "CLICKHOUSE_PASSWORD=$(generate_secret)"
    echo "SECRET_KEY=$(generate_secret)"
    echo "DATASOURCE_SECRET_KEY=$(generate_secret)"
} >> "$ENV_FILE"

echo "Done: ${ENV_FILE} saved."
