#!/bin/sh
# Enter entrypoint commands here
python manage.py collectstatic --no-input --clear
gunicorn container.wsgi --name servicename --workers 3 --timeout 69 --bind 0.0.0.0:8000
exec "$@"
