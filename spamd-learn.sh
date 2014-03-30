#!/bin/bash
# update spamd with spam/ham
sa-learn --no-sync --spam ~/users/dh/.Spam/cur/
sa-learn --no-sync --spam ~/users/dh/.Trash/cur/
sa-learn --no-sync --ham ~/users/dh/cur/*
sa-learn --sync
