# ---------- Builder Stage ----------
FROM python:3.13-slim AS builder
WORKDIR /app

RUN python -m venv /venv
ENV PATH="/venv/bin:$PATH"

COPY requirements.txt .
RUN pip install --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# ---------- Runtime Stage ----------
FROM python:3.13-slim
WORKDIR /app

ENV PYTHONUNBUFFERED=1 \
    PATH="/venv/bin:$PATH"

RUN useradd --create-home appuser

COPY --from=builder /venv /venv
COPY app ./app

RUN chown -R appuser:appuser /app
USER appuser

EXPOSE 8000
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
