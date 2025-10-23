"""
Production settings for live server
"""
from .base import *

DEBUG = False

allowed = os.environ.get(
    'DJANGO_ALLOWED_HOSTS',
    'mikhailkondratev.online,www.mikhailkondratev.online,mikhailkondratev.ru,www.mikhailkondratev.ru',
)
ALLOWED_HOSTS = [h.strip() for h in allowed.split(',') if h.strip()]

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'u3303092_default',
        'USER': 'u3303092_default',
        'PASSWORD': '8hy72eiTqxfHLJR8',
        'HOST': 'localhost',
    }
}

STATIC_ROOT = BASE_DIR / 'static'
