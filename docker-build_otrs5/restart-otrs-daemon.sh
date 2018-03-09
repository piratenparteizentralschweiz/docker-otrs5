#!/bin/bash

docker exec otrs su -c "cd /opt/otrs; bin/otrs.Daemon.pl stop; bin/otrs.Daemon.pl start" otrs

