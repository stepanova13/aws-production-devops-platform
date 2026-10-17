
FROM python:3.12-slim

WORKDIR /app

# Install Python dependencies
COPY app/requirements.txt .
RUN python -m pip install --no-cache-dir --upgrade pip setuptools \
    && python -m pip install --no-cache-dir -r requirements.txt

# Create an unprivileged application user
RUN groupadd --system app && \
    useradd --system --gid app --create-home app

# Copy application files and assign ownership
COPY --chown=app:app app/ .

# Run the application without root privileges
USER app

EXPOSE 5000

CMD ["python", "app.py"]

