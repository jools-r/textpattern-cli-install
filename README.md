# Textpattern CLI installation

Install Textpattern CMS in seconds from the command line with this shell script for automatic creation of a database and Textpattern installation based on site specifications defined in a `setup.json` file.



## Prerequisites

* Shell access (this example runs on MacOS with a zsh shell)
* A (local) web server with active git, php and mysql services
* [jq](https://jqlang.org/download/) installed in your shell



## Description

This repo comprises two files: 
- `setup_textpattern.zsh` - a shell script. Set up once and re-use, and 
- `setup.json` - a config file containing the configuration for each new site.

In the standard setup, the script pulls [the current dev branch of Textpattern](https://github.com/textpattern/textpattern/tree/dev) from GitHub, prunes all descriptive text files, repo config files and typically unused folders, reads the setup configuration in `setup.json`, creates the database if it does not already exist and installs Textpattern.

The result is a clean, ready-to-use Textpattern installation with a preconfigured admin user, perfect for quickly spinning up test sites on a local web server.

This principle can be adapted to setup a Textpattern site with a custom start configuration, or based on the release branch of Textpattern.



## Installation


### Option A – In you local site folder (once per site)

* Create a folder in your web root to hold your site.
* Save `setup_textpattern.zsh` as a text file in this folder.
* Open a Terminal at this folder (on Mac: right-click on the folder in the Finder and choose _Services › New Terminal at Folder_).
* Enter `chmod +x setup_textpattern.zsh` + ENTER to make the setup file executable.

Continue below with "Usage".


### Option B – For system-wide use (re-usable)

* Either open a fresh Terminal at a folder that you already know to be in your `PATH` variable such as `usr/local/bin` or create a separate folder to hold your own executable scripts, e.g.:
  * Open a fresh Terminal and type `cd ~` + ENTER to go to your home directory.
  * Type `mkdir bin` to create a folder called `bin` (if this does not already exist).
  * Type `vim ~/.zshrc` to open the zsh shell environment variable settings file.
  * Press `i` to start editing, find or make a free line (e.g. alongside other PATH settings) and type `export PATH=~/bin:$PATH`.
  * Press `ESC` and type `:wq` to save the changes.
  * Close and restart your Terminal. From now on, executable scripts saved in this folder should be reachable system-wide.
* Still in the Terminal: save `setup_textpattern.zsh` as a text file to the folder you chose/created above.
* Run `chmod +x setup_textpattern.zsh` to make the setup file executable.

Continue below with "Usage".



## Usage

* Create a folder in your web root folder to hold your site (if not already created earlier). If your host or local web server requires you to set up any domain details / databases, do this now. 
* Save `setup.json` as a text file into this folder.
* Open `setup.json` in a text editor and modify to match your site's configuration. Not all details are required, but you will need:
  - public_url
  - your MySQL connection and db details
  - user credentials for a predefined admin user
* Open a Terminal window in your site's folder and run `./setup_textpattern.zsh`.
* The script should execute and report on its progress, for example:

```
Cloning into 'textpattern'...
remote: Enumerating objects: 100074, done.
remote: Counting objects: 100% (934/934), done.
remote: Compressing objects: 100% (325/325), done.
remote: Total 100074 (delta 781), reused 680 (delta 606), pack-reused 99140 (from 3)
Receiving objects: 100% (100074/100074), 51.93 MiB | 21.87 MiB/s, done.
Resolving differences: 100% (71060/71060), done.
Deleted: textpattern/.git
Deleted: textpattern/.github
Deleted: textpattern/.gitignore
Deleted: textpattern/.gitattributes
Deleted: textpattern/.phpstorm.meta.php
Deleted: textpattern/phpcs.xml
Deleted: textpattern/composer.lock
Deleted: textpattern/composer.json
Deleted: textpattern/package.json
Deleted: textpattern/HISTORY.txt
Deleted: textpattern/UPGRADE.txt
Deleted: textpattern/INSTALL.txt
Deleted: textpattern/LICENSE.txt
Deleted: textpattern/README.txt
Deleted: textpattern/README.md
Deleted: textpattern/CONTRIBUTING.md
Deleted: textpattern/CODE_OF_CONDUCT.md
Deleted: textpattern/SECURITY.md
Deleted: textpattern/rpc
Deleted: textpattern/sites
Enter password: 
Enter password: 
Database your_sitename_db created.
[OK]	Connected
[OK]	Using your_sitename_db (utf8mb4).
[OK]	Creating database tables
[OK]	Lang: 'en'
[OK]	Prefs: 'data/core'
[OK]	Import: 'data/txp_category'
[OK]	Import: 'data/txp_link'
[OK]	Import: 'data/txp_section'
[OK]	Import: 'articles/articles.welcome'
[OK]	Public theme: 'four-point-nine'
[OK]	That went well!
```

Depending on your connection and computer, this usually takes less than a minute, often just 10-20 seconds.

Your site is ready to go: open it in your browser and sign in to the admin area using the login details you specified.


**Example with [Laravel Valet](https://laravel.com/docs/valet) on a Mac**

Laravel Valet sets up a low-overhead always-on web server with php and mysql running as background services. It maps any folder in the `~/Sites` folder to the site url `name-of-folder.test` making it very easy to create new sites. You just need [git](https://git-scm.com/downloads) and [jq](https://jqlang.org/download/) already installed on your system. If you have setup the install script for system-wide use, spinning up a new site is as easy as:

* Create a new folder named after the site name in the MacOS `Sites` folder.
* Copy `setup.json` into this folder
* Edit `setup.json` to match the site's name and your desired database name. If your standard admin user doesn't change, there's often nothing more to change.
* Open a Terminal window at your folder and run `./setup_textpattern.zsh`.

Your site is installed and immediately reachable in your browser at `http://name-of-folder.test`. 


**Bonus: set up an alias for easier use**

* Open a Terminal window, and enter `vim .zshrc` to open the zsh shell environment variable settings file.
* Press `i` to begin editing. On a free line enter `alias setup_txp="~/bin/setup_textpattern.zsh"` (adapt to match where you saved your script).
* Press `ESC` and type `:wq` to save the changes.
* Close and restart your Terminal. From now on, you can start the script by entering `setup_txp` in the Terminal.



## Adapting to own scenarios


### Adapting setup_textpattern.zsh

* You can rename the file if desired. Equally you can use an alias name of your choosing.
* If you prefer to keep certain files & folders in your Textpattern installation, edit the `TO_DELETE` variable in the script in a text editor.
* If you want to copy a different branch, edit the `REPO_BRANCH` variable to match the desired branch name, e.g. `REPO_BRANCH="main"` for the release branch.
* If you want to use a different name for the config file, edit the `SETUP_JSON` variable to match your filename. It must be in json format.
* Create several versions of the installer for different pre-configured quick-install options.

### Adapting your site’s start configuration

* Extend the `setup_textpattern.zsh` script to copy in desired test files or insert a pre-prepared .sql file to the database with initial settings.
* Supply a different `content_directory` to start with your own initial content. By default, the setup script uses the details supplied in the `articles`, `themes` and `data` folders in the [/textpattern/setup/](https://github.com/textpattern/textpattern/tree/dev/textpattern/setup/) folder. Follow this pattern for your own details.

### Adapting for offline use or non-git-capable servers (TODO)

* Instead of cloning the current dev/main branch from the GitHub repo, `setup_textpattern.zsh` could be adapted to make a copy of a pre-existing blank installation folder saved elsewhere on your computer. Unneeded files and/or add further desired files could be added to this folder as required.
* 

## Contributions welcome

* Instructions for use on Windows, Linux, or with other local web servers welcome.


## Credits

The Textpattern devs and team, especially [Pete Cooper](https://github.com/petecooper) for his example of the demo installer and [makss](https://github.com/makss) for adding the CLI installation facility to the setup installer back in 2017.


## Changelog

* v1.0 – Initial version – 20 Oct 2025
