from fastapi import FastAPI

from .routes import api

app = FastAPI(
    openapi_url="/api/openapi.json",
    docs_url="/api/docs",
    redoc_url="/api/redoc",
)

app.include_router(api, prefix="/api")
