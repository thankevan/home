#!/bin/bash


echo
echo "Correct user?"
echo '$USER:staff' "=> $USER:staff"

echo
echo "Current ownership:"
ls -al -G /Applications/Slack.app

echo
echo "Make the switch"
sudo chown -R $USER:staff /Applications/Slack.app

echo
echo "Now:"
ls -al -G /Applications/Slack.app

