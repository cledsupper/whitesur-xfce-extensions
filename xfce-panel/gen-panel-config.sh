#!/usr/bin/env bash

echo "Generating panel configuration..."
mv config-light.txt config.txt
tar -cvjSf lesso-whitesur-light.tar.bz2 launcher-12 launcher-2 config.txt
mv config.txt config-light.txt
mv config-dark.txt config.txt
tar -cvjSf lesso-whitesur-dark.tar.bz2 launcher-12 launcher-2 config.txt
mv config.txt config-dark.txt

echo "FINISHED!"
echo "Open your panel preferences and apply configuration from a backup file"
echo "by cleds.upper"
