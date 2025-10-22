from django.core.management.base import BaseCommand
from django.conf import settings
import os

class Command(BaseCommand):
    help = 'Touch .restart-app to request Passenger to restart the application (or similar hosts)'

    def add_arguments(self, parser):
        parser.add_argument('--path', help='Project root path (defaults to settings.BASE_DIR)')

    def handle(self, *args, **options):
        project_root = options.get('path') or settings.BASE_DIR
        restart_file = os.path.join(project_root, '.restart-app')
        try:
            with open(restart_file, 'w') as f:
                f.write('restart')
            self.stdout.write(self.style.SUCCESS(f'Touched {restart_file}'))
        except Exception as e:
            self.stderr.write(self.style.ERROR(f'Failed to touch {restart_file}: {e}'))
