from fastapi import FastAPI

app = FastAPI()


@app.get("/health")
def health():
    return {"status": "healthy", "service": "task-manager"}


@app.get("/tasks")
def get_tasks():
    return {"tasks": [{"id": 1, "title": "Learn Docker"}]}
