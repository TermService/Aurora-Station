# Aurorastation

**[Website](https://aurorastation.org/)**

**[Code](https://github.com/Aurorastation/Aurora.3)**

[![Krihelimeter](http://www.krihelinator.xyz/badge/Aurorastation/Aurora.3)](http://www.krihelinator.xyz/repositories/Aurorastation/Aurora.3)

[![Build Status](https://travis-ci.org/AltHub-Team/Aurora-Station.svg?branch=master)](https://travis-ci.org/AltHub-Team/Aurora-Station)

---

### LICENSE
Aurorastation is licensed under the GNU Affero General Public License version 3, which can be found in full in LICENSE.

Commits with a git authorship date prior to `1420675200 +0000` (2015/01/08 00:00) are licensed under the GNU General Public License version 3, which can be found in full in LICENSE-GPL3.txt.

All commits whose authorship dates are not prior to `1420675200 +0000` are assumed to be licensed under AGPL v3, if you wish to license under GPL v3 please make this clear in the commit message and any added files.

If you wish to develop and host this codebase in a closed source manner you may use all commits prior to `1420675200 +0000`, which are licensed under GPL v3.  The major change here is that if you host a server using any code licensed under AGPLv3 you are required to provide full source code for your servers users as well including addons and modifications you have made.

See [here](https://www.gnu.org/licenses/why-affero-gpl.html) for more information.

### GETTING THE CODE
The simplest way to obtain the code is using the github .zip feature.

Click [here](https://github.com/Aurorastation/Aurora.3/archive/master.zip) to get the latest stable code as a .zip file, then unzip it to wherever you want.

The more complicated and easier to update method is using git.  You'll need to download git or some client from [here](http://git-scm.com/).  When that's installed, right click in any folder and click on "Git Bash".  When that opens, type in:

    git clone https://github.com/Aurorastation/Aurora.3.git

(hint: hold down ctrl and press insert to paste into git bash)

This will take a while to download, but it provides an easier method for updating.

### INSTALLATION

First-time installation should be fairly straightforward.  First, you'll need BYOND installed.  You can get it from [here](http://www.byond.com/).

This is a sourcecode-only release, so the next step is to compile the server files.  Open aurorastation.dme by double-clicking it, open the Build menu, and click compile.  This'll take a little while, and if everything's done right you'll get a message like this:

    saving aurorastation.dmb (DEBUG mode)

    aurorastation.dmb - 0 errors, 0 warnings

If you see any errors or warnings, something has gone wrong - possibly a corrupt download or the files extracted wrong, or a code issue on the main repo. Ask on the server Discord if you're completely lost.

Once that's done, open up the config folder.  You'll want to edit config.txt to set the probabilities for different gamemodes in Secret and to set your server location so that all your players don't get disconnected at the end of each round.  It's recommended you don't turn on the gamemodes with probability 0, as they have various issues and aren't currently being tested, so they may have unknown and bizarre bugs.

You'll also want to edit admins.txt to remove the default admins and add your own.  "Game Master" is the highest level of access, and the other recommended admin levels for now are "Game Admin" and "Moderator".  The format is:

    byondkey - Rank

where the BYOND key must be in lowercase and the admin rank must be properly capitalised.  There are a bunch more admin ranks, but these two should be enough for most servers, assuming you have trustworthy admins.

Finally, to start the server, run Dream Daemon and enter the path to your compiled aurorastation.dmb file.  Make sure to set the port to the one you  specified in the config.txt, and set the Security box to 'Trusted'.  Then press GO and the server should start up and be ready to join.

---

### UPDATING

To update an existing installation, first back up your /config and /data folders
as these store your server configuration, player preferences and banlist.

If you used the zip method, you'll need to download the zip file again and unzip it somewhere else, and then copy the /config and /data folders over.

If you used the git method, you simply need to type this in to git bash:

    git pull

When this completes, copy over your /data and /config folders again, just in case.

When you have done this, you'll need to recompile the code, but then it should work fine.

---

### Configuration

For a basic setup, simply copy every file from config/example to config.

For more advanced setups, setting the server `tick_lag` in the config as well as configuring SQL are good first steps.

---

### SQL Setup

The SQL backend for the library and stats tracking requires a MySQL server, as does the optional SQL saves system. Your server details go in config/dbconfig.txt, and initial database setup is done with [flyway](https://flywaydb.org/). Detailed instructions can be found [here](https://github.com/Aurorastation/Aurora.3/tree/master/SQL).

---

### Discord Bot

The Aurorastation codebase uses a built-in Discord bot to interface with Discord. Some of its features rely on the MySQL database, specifically, channel storage and configuration. So a database is required for its operation. If that is present, then setup is relatively easy: simply set up the `config/discord.txt` file according to the example located in the `config/example/` folder, and populate the database with appropriate channel and server information.

At present, there is no built in GUI for doing the latter. So direct database modification is required unless you set up the python companion bot. The python companion bot is BOREALIS II, and can be located [here](https://github.com/Aurorastation/BOREALISbot2). Though not required, it makes database modification easier. See commands that start with `channel_`.
