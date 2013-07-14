# Workify for Chrome

Workify is a productivity toolkit for Chrome.

It delays access to unproductive sites and shows you a list of things you should be doing. It will also allow you to permanently block sites, and will later track how long you spend on unproductive sites, warning you every 30 minutes or so.

## Feature List

### v0.1
* Delay before showing site
* Show a to do list or a reading list where the page would be
    * Split into high and low energy tasks
    * Could integrate with a site like Pocket and/or Trello

### v0.2
* Permanently block certain sites

### v0.3
* Track how long you've spent on certain sites
* Alert you after a certain amount of time on an unproductive site
    * Show you how much you could have made on minimum wage during that time?

### v0.4
* Focus Mode
    * Permanently blocks certain sites
    * Allows time limited access to other sites
    * Based on the pomodoro technique?

### v0.5
* Replace default new tab page with list

## To do list

### Non-product
* Write some tests - TDD/BDD
* Get a solid build system working

### Micro
#### Features
* Implement task reordering
* Support adding links in a really nice way
    * Automatically fetch the title of the page and add the link into the low energy list
    * Maybe with nice reading icon instead of the dot?

#### Bugs
* Fix block page collapsed UI
* Don't block facebook api request dialogs
* Implement tracking of what page a safeTab can access
    (this means a page that can browse reddit can't then go on facebook)

### Macro
* Perma-blocking
* Track time spent on a site
