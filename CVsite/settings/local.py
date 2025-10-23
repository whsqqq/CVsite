"""
Local development settings
"""
from .base import *

DEBUG = True
ALLOWED_HOSTS = ['127.0.0.1', 'localhost']

# SQLite for local development (simpler and faster)
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'db.sqlite3',
    }
}

# Serve static files directly from /static directory during development
STATICFILES_DIRS = [BASE_DIR / 'static']
