# ArtAuto

This software is for "ArtAuto" auto service. In this software, a responsible employee can write cars in the service queue and print work orders.

## Features

1. Write cars in service queue.
2. Create work orders and print it to clients.

## Before using
You need to change passwords in scripts:

1. [apex.sql](coding/db_scripts/sys/users/apex.sql)
2. [install.sh](install.sh)

## Installer for Oracle objects

If your operation system is Windows then you need to download [GitBash](https://git-scm.com/download/win) tool for executing shell script "install.sh". The script dynamically creates script and installs objects in preset order.