# passenger_wsgi.example.py
# Copy this file to passenger_wsgi.py and update the two sys.path.insert lines

import os
import sys

# Replace these two paths with real paths on your host
# Example project_root: /var/www/u0000006/data/www/mikhailkondratev.ru
# Example venv_site_packages: /var/www/u0000006/data/djangoenv/lib/python3.11/site-packages
project_root = '/path/to/your/project_root'  # <-- edit
venv_site_packages = '/path/to/venv/lib/pythonX.Y/site-packages'  # <-- edit

# Ensure project root is on sys.path
sys.path.insert(0, project_root)
# If you use a virtualenv, add its site-packages so Passenger can find installed packages
if venv_site_packages:
    sys.path.insert(1, venv_site_packages)

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'CVsite.settings')

from django.core.wsgi import get_wsgi_application
application = get_wsgi_application()
