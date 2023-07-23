A sample command-line application with an entrypoint in `bin/`, library code
in `lib/`, and example unit test in `test/`.


*DOCS*
This is a command line application built completely on dart to simulate the feature in discord.

*Prerequisites*
Dart SDK 3.0.5
Sembast Version: 3.4.9

*Installation*
1. Clone the repository

    `git clone  git@github.com:dhruv2981/Discord_like_cli.git`

2. Enter into the project repo and install the dependancies

    `dart pub get`

3. Run any of the commands in the given below



# Input Commands

### register: to register the user in mydiscord cli
### login: to login into mydiscord cli
### logout: to logout of mydiscord cli
### current_user: print the name of current user
### open_chats: to open personal messages inbox
### send_chat: to send personal dm
### open_c_message: to open a channel inbox
### send_c_message: send message in a channel
### join_server: to join a existing server
### create_server: to create a server
### add_channel: to add a channel in a server
### show_channels: to print channels in a server
### exit: to move out of shell
### add_category: to add a category in a server
### add_chan_to_cat: to move a direct channel into a existing category
### show_server_structure: to see categories and channels in a server
### mod_users:to print mod users in server


#### Note: 

1. channel can be made with a user of mod/admin role and channel type will be asked only if user is first one to add_channel      
2. if channel already exist u dont need to tell type of channel as only a unique channel name in a server






#### There are three types of users
Admin,Mod user,Newbie
-:Admin and mod users can only create a new channel and new category
-:If the channel and category are already present in server then newbie user can also join that channel.

#The channel name in a server is unique.

#Brownie points:
-:Admin and mod have power to put a direct channel in server into any existing category.
-:Admin and mod users can only create a new channel and new category
-:Colour coding of cli
-:One can print full structure of server which shows all the channels and categories in it.
-:New user in channel has power to be mod using mod access password.