#!/bin/sh

sudo usermod -aG docker ${USER}
su - ${USER}

