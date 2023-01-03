# AuctionQuickSell
A simple wow addon to quickly sell things too the auction house

## How this works
The Azerothcore Auctionneer bot https://github.com/azerothcore/mod-ah-bot is setup to buy things at various multiples of the vendor price depending on rarity.
This addon simply creates auctions based on the multiple provided by the user for each item rarity it can be automated by turning on auto mode or can instead be done by clicking a button if you wish to not accidently sell too much.

## Commands
typing **/aucqs help** will provide a list of available commands but i'll also list them here
### Currentvalues
Displays all user definable values
### Autochange
This changes the autosell mode
### Autostate
This returns the current state of autosell
### Stackchange
This enables or disables the selling of all avaiable items of that id
### Stackstate
This lets you know if the stacksell feature is enabled
### Grey/White/Green/Blue/Purple/Orange
on it's own to find out the current multiplier or follow it with a number to change that value
### Bidunder/Buyoutunder
returns the % under the maximum theoretical price follow this with a whole number to set a new percent




