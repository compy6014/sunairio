from fastapi import FastAPI, Query
from fastapi.responses import JSONResponse

app = FastAPI(title="Simple web app", version="1.0.0")

@app.get("/add")
def add(left: int = Query(...), right: int = Query(...)):
    return JSONResponse(content={"sum": left + right})

@app.get("/health")
def health():
    return {"status": "OK"}