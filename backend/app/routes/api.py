import asyncio

from fastapi import APIRouter
from pydantic import BaseModel

api = APIRouter()


class Message(BaseModel):
    message: str


@api.get("/hello", response_model=Message)
async def hello():
    await asyncio.sleep(0.5)
    return Message(message="Hello, world!")
