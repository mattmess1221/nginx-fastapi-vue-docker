#!/usr/bin/env python
import asyncio
import http

from fastapi import FastAPI, Request, Response
from fastapi.responses import JSONResponse
from pydantic import BaseModel
from starlette.middleware.base import RequestResponseEndpoint
from starlette import status

app = FastAPI(
    root_path="/api",
)


@app.middleware("http")
async def fix_root_path(request: Request, next: RequestResponseEndpoint) -> Response:
    # Fix the root path messing up endpoint resolution in case the proxy doesn't strip it
    # https://github.com/nginx/unit/issues/530

    path = request.scope['path']
    root_path = request.scope['root_path']

    if path.startswith(root_path):
        # strip the root path and continue
        path = path[len(root_path):]
        request.scope['path'] = path
        return await next(request)

    # Anything not in root_path should be considered not found
    exc = http.HTTPStatus.NOT_FOUND
    return JSONResponse({"detail": exc.phrase}, exc.value)


class Message(BaseModel):
    message: str


@app.get("/hello", response_model=Message)
async def hello():
    await asyncio.sleep(0.5)
    return Message(message="Hello, world!")


if __name__ == '__main__':
    import uvicorn
    uvicorn.run("app:app", debug=True, reload=True)
