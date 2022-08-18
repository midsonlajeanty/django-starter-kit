.PHONY: clean install freeze migrate run

# If the first argument is "run"...
ifeq (create-app,$(firstword $(MAKECMDGOALS)))
  # use the rest as arguments for "run"
  APP_NAME := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  # ...and turn them into do-nothing targets
  $(eval $(APP_NAME):;@:)
endif

VENV_NAME?=venv
PYTHON=$(VENV_NAME)/bin/python
PIP=$(VENV_NAME)/bin/pip

HOST=127.0.0.1
PORT=8080

clean:
	rm -rf venv
	rm -rf db.sqlite3
	find . -type f -name '*.py[co]' -delete -o -type d -name __pycache__ -delete

install:
	test -d $(VENV_NAME) || python3 -m venv $(VENV_NAME)
	$(PIP) install -r requierments.txt
	$(PYTHON) manage.py migrate

freeze:
	$(PIP) freeze > requierments.txt

migrate:
	$(PYTHON) manage.py makemigrations
	$(PYTHON) manage.py migrate

create-app:
	cd apps && ../$(PYTHON) ../manage.py startapp $(APP_NAME) && cd ..

run:
	$(PYTHON) manage.py runserver $(HOST):$(PORT)
