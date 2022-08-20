.PHONY: clean install freeze migrate run

ifeq (create-app,$(firstword $(MAKECMDGOALS)))
  APP_NAME := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(APP_NAME):;@:)
endif

VENV_NAME?=venv
PYTHON=$(VENV_NAME)/bin/python
PIP=$(VENV_NAME)/bin/pip

HOST=127.0.0.1
PORT=8080

clean:
	rm -rf venv
	rm -f db.sqlite3 .env
	find . -type f -name '*.py[co]' -delete -o -type d -name __pycache__ -delete

prepare-env:
	test -d $(VENV_NAME) || python3 -m venv $(VENV_NAME)
	test -d .env || cp .env.template .env

install: clean prepare-env
	$(PIP) install -r requirements.txt
	$(PYTHON) manage.py migrate
	test -d media || mkdir media
	test -d static || mkdir static
	test -d templates || mkdir templates

freeze:
	$(PIP) freeze > requirements.txt

migrate:
	$(PYTHON) manage.py makemigrations
	$(PYTHON) manage.py migrate

create-app:
	cd apps && ../$(PYTHON) ../manage.py startapp $(APP_NAME) && cd ..

run:
	$(PYTHON) manage.py runserver $(HOST):$(PORT)
