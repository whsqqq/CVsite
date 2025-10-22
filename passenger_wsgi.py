import os, sys

sys.path.insert(0, '/var/www/u3303092/data/www/mikhailkondratev.ru/CVsite/')
sys.path.insert(1, '/var/www/u3303092/data/www/mikhailkondratev.ru/.venv/lib/python3.10/site-packages/')

os.environ['DJANGO_SETTINGS_MODULE'] = 'CVsite.settings'

from django.core.wsgi import get_wsgi_application
application = get_wsgi_application()
