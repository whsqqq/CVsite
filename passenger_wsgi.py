# -*- coding: utf-8 -*-
"""
Passenger WSGI entry-point template.
Edit the sys.path entries to match your host provider paths.
"""
import os
import sys

# Example paths (edit for your host):
# sys.path.insert(0, '/var/www/youruser/www/yourdomain.com/project')
# sys.path.insert(1, '/var/www/youruser/djangoenv/lib/python3.x/site-packages')

# Add project base dir
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(BASE_DIR))

# If you use a virtualenv on the host, add its site-packages path here
# sys.path.insert(1, '/path/to/virtualenv/lib/pythonX.Y/site-packages')

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'CVsite.settings')

from django.core.wsgi import get_wsgi_application

application = get_wsgi_application()
