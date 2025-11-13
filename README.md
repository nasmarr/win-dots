The goal of this repo is to store a few essentials for what I think is a decent Windows environment that can be used for development and gaming.

It should contain a few config files and an install script to do the magic of installing the applications I like and updating their configs with the configs stored in this repo.

To run the install script, execute the following commands in a powershell terminal:
~~~
cd $env:USERPROFILE
git clone https://github.com/nasmarr/win-dots.git
cd win-dots
powershell -ExecutionPolicy Bypass -File install.ps1
~~~
