FROM docker.io/python:3.11 as build-backend

ENV PIP_NO_CACHE_DIR=1 \
    PIP_ROOT_USER_ACTION=ignore \
    POETRY_VIRTUALENVS_IN_PROJECT=true

RUN pip install -U pip setuptools wheel -q && \
    pip install poetry==1.6.1 -q

WORKDIR /app/backend

COPY backend/pyproject.toml backend/poetry.lock ./
RUN poetry install --only main --no-root --sync --no-cache
COPY backend/app/ app/


FROM docker.io/node:18 as build-frontend

ENV npm_config_update_notifier=false

RUN corepack enable

WORKDIR /app/frontend

COPY frontend/package.json frontend/pnpm-lock.yaml ./
RUN pnpm fetch

COPY frontend/*.config.js frontend/index.html ./
COPY frontend/src src/
COPY frontend/public public/

RUN pnpm install
RUN pnpm build


FROM docker.io/nginx/unit:1.29.1-python3.11

WORKDIR /app

COPY --from=build-backend /app/backend backend
COPY --from=build-frontend /app/frontend/dist frontend

COPY docker/config.json /docker-entrypoint.d/config.json
