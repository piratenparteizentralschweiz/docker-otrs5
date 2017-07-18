#!/bin/bash

su -c 'createuser --username=postgres --no-superuser --pwprompt otrs' postgres
su -c 'createdb --username=postgres --owner=otrs --encoding=UNICODE otrs' postgres
