FROM python:3.9 as build-backend

RUN pip install -U pip setuptools wheel && \
    pip install poetry==1.6.1

WORKDIR /app/backend
ENV POETRY_VIRTUALENVS_IN_PROJECT=true

COPY backend/pyproject.toml backend/poetry.lock ./
COPY backend/app/ app/
RUN poetry install --only main


FROM node:16.20.2-alpine3.18 as build-frontend

WORKDIR /app/frontend

COPY frontend/package.json frontend/*.config.js frontend/yarn.lock ./
RUN yarn install

COPY frontend/src src/
COPY frontend/public public/

RUN yarn build


FROM nginx/unit:1.26.1-python3.9

WORKDIR /app

COPY --from=build-backend /app/backend backend
COPY --from=build-frontend /app/frontend/dist frontend

COPY docker/config.json /docker-entrypoint.d/config.json

