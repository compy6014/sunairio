# ---------- Builder Stage ----------
FROM python:3.13-slim AS builder

WORKDIR /install

# Upgrade pip & install dependencies directly to /install to avoid virtualenv
COPY requirements.txt .
RUN pip install --upgrade pip \
    && pip install --prefix=/install --no-cache-dir -r requirements.txt


# ---------- Runtime Stage ----------
FROM python:3.13-slim

WORKDIR /app

ENV PYTHONUNBUFFERED=1 \
    PATH="/install/bin:$PATH"

# Create non-root user
RUN useradd --create-home appuser

# Copy installed dependencies from builder
COPY --from=builder /install /install

# Copy application code
COPY app ./app

# Change ownership for non-root execution
RUN chown -R appuser:appuser /app
USER appuser

EXPOSE 8000

# Optional: Healthcheck to allow CI to know when container is ready
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')" || exit 1

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
