Подготовка и деплой Django-проекта (короткая инструкция)

1) Подготовка окружения на хостинге

- Подключитесь по SSH к хостингу.
- Перейдите в домашнюю директорию: `cd ~`.
- Создайте виртуальное окружение (пример для Python 3.11):

  python3.11 -m venv venv
  source venv/bin/activate

- Обновите pip и установите зависимости:

  pip install --upgrade pip
  pip install -r /path/to/your/project/requirements.txt

- (Если используете MySQL) установите системные библиотеки и клиент (на хостинге это обычно делается через панель).

2) Перенос проекта в рабочую папку

- Перенесите/скопируйте файлы проекта в каталог сайта на хостинге (например `/var/www/youruser/www/yourdomain`).
- В корне проекта создайте `.env` по образцу `.env.example` и заполните значения.

3) Настройки Django

- В `CVsite/settings.py` проект уже поддерживает чтение секретов из переменных окружения.
- Убедитесь, что `DJANGO_ALLOWED_HOSTS` содержит ваш домен.

4) Сбор статики и миграции

  source venv/bin/activate
  cd /path/to/your/project
  python manage.py collectstatic --noinput
  python manage.py migrate --noinput

5) Passenger / Phusion Passenger (пример)

- Создайте `passenger_wsgi.py` в корне сайта (в проекте есть шаблон `passenger_wsgi.py`).
- Отредактируйте пути внутри `passenger_wsgi.py`, чтобы они указывали на ваш проект и virtualenv site-packages.
- В панели управления хостинга включите поддержку Python/Passenger (если требуется).

6) Перезапуск

- Для перезапуска создайте файл `.restart-app` в корне сайта или используйте интерфейс хостинга.

7) Отладка

- Логи обычно находятся в панели хостинга или в файлах `passenger-log`/`error-log`.

Если нужно, могу подготовить точные команды под ваш хостинг (укажите путь к каталогу сайта и версию Python на хостинге).

Более подробная пошаговая инструкция (готовые команды)

На сервере (предполагаем подключение по SSH и что вы находитесь в домашней директории пользователя):

1) Перейдите в каталог сайта и обновите код (если используете git):

```bash
cd /path/to/your/site   # замените на реальный путь, например /var/www/u123456/data/www/mikhailkondratev.ru
git pull origin main
```

2) Создайте и активируйте виртуальное окружение (используйте нужную версию Python):

```bash
# пример для Python 3.11, измените на требуемую версию
python3.11 -m venv venv
source venv/bin/activate
```

3) Установите зависимости:

```bash
pip install --upgrade pip
pip install -r requirements.txt
```

4) Подготовьте `.env` (в корне проекта) — пример с heredoc:

```bash
cat > .env <<'ENV'
DJANGO_SECRET_KEY=replace-with-your-secret
DJANGO_DEBUG=False
DJANGO_ALLOWED_HOSTS=mikhailkondratev.online,www.mikhailkondratev.online,mikhailkondratev.ru,www.mikhailkondratev.ru
# Если используется MySQL, добавьте эти переменные
# MYSQL_NAME=your_db
# MYSQL_USER=your_user
# MYSQL_PASSWORD=your_password
# MYSQL_HOST=localhost
# MYSQL_PORT=3306
ENV

# export vars to the runtime environment (example)
export $(grep -v '^#' .env | xargs)
```

5) Сбор статики и миграции:

```bash
python manage.py collectstatic --noinput
python manage.py migrate --noinput
```

6) Passenger / Phusion Passenger

- Разместите `passenger_wsgi.py` в корне сайта (в репозитории есть `passenger_wsgi.py` — отредактируйте пути под ваш хост). Пример пути, который нужно заменить в файле:

```py
# sys.path.insert(0, '/var/www/u0000006/data/www/faq-reg.ru/project_name')
# sys.path.insert(1, '/var/www/u0000006/data/djangoenv/lib/python3.7/site-packages')
```

- В `passenger_wsgi.py` укажите путь до вашего проекта (директория, где находится `manage.py`) и путь до site-packages виртуального окружения.

7) Перезапуск

```bash
# Для многих хостингов создание файла .restart-app перезапускает приложение
touch .restart-app
```

8) Просмотр логов: используйте панель хостинга или ищите файлы логов Passenger/error_log.

English quick checklist

- SSH to server and go to site dir
- Create & activate venv
- pip install -r requirements.txt
- Create `.env` with required vars
- python manage.py collectstatic && migrate
- Edit `passenger_wsgi.py` to match your paths
- touch .restart-app to restart

If you want, provide the exact paths (project root and virtualenv site-packages) and I will update `passenger_wsgi.py` for you.