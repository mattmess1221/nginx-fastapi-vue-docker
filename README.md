# nginx-fastapi-vue-docker

Example application for running a web application with [Vue.js](https://vuejs.org/)
as a frontend and [FastAPI](https://fastapi.tiangolo.com/) as a backend using nginx
in a single docker image and container.

To allow for a single image, [nginx unit](https://unit.nginx.org/) is used to
pass requests directly to the asgi application.

## Development

The `backend` folder contains a [Python Poetry](https://python-poetry.org/) project
using the FastAPI framework. Use the following commands to start developing.

```shell
cd backend
poetry install
poetry run uvicorn app:app --debug --reload
```

The `frontend` folder contains a [Pnpm](https://pnpm.io/) project using the
Vue.js framework. Use the following commands to start developing.

```shell
cd frontend
pnpm install
pnpm dev
```

After both the frontend and backend are up, you can visit http://localhost:8080/ to
view the app.

## Configuration
To configure nginx-unit, modify the `docker/config.json` file using the provided
[guide](https://unit.nginx.org/configuration/).

## Building
The docker build takes advantage of multi-stage builds, so docker 17.05+ is needed.

To build, simply run
```shell
docker build . -t nginx-fastapi-vue-docker
```

Then to run, use 
```shell
docker run --rm -p 80:80 nginx-fastapi-vue-docker
```

You now be able to open http://localhost/ and see your application.
