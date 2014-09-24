#!/bin/bash
# update spamd with spam/ham
# todo: make it univeral for all vusers
sa-learn --no-sync --spam ~/users/dh/.Spam/cur/
sa-learn --no-sync --ham ~/users/dh/cur/*
sa-learn --sync
