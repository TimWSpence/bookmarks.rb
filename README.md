Bookmarks Manager
==================

I have yet to find a good bookmark syncing application or way of
managing my bookmarks so wrote this as an experiment.

The idea is to dump bookmarks into a YAML file of the format
```yaml
---

bookmarks:
- name: one
  url: http://foo.com
  tags:
  - one
  - example
- name: two
  url: https://bar.com
  tags:
  - two
  - example
```

and then have a tool which offers the following operations:
* list
* search
* add
* import (a one-time operation to parse a chrome HTML export of bookmarks
  into the above format)

The key advantages I see this offering are:
1. The data format is plain text so can be easily version controlled, edited, etc
2. The ability to attach metadata (tags) to enable more complex querying for
   bookmarks
3. Entirely browser-agnostic (although does require running a terminal as well
   to search for bookmarks but most terminal emulators will allow you to directly
   open links by clicking on them so I don't see this being prohibitively painful)

Installation
------------

```sh
git clone https://github.com/TimWSpence/bookmarks.git ~/dev/bookmarks
cd ~/dev/bookmarks
bundle
./bm --help
```

You might want to consider adding this directory to your path (in .bashrc, etc):
```sh
export PATH=$PATH:$HOME/dev/bookmarks
```
to enable usage from anywhere as
```sh
bm --help
```

Using a different location for the bookmarks file
-------------------------------------------------

If you wish to keep your bookmarks file in a different location (eg a git repo)
then you can specify the location in a .bookmarks file in the same directory
as the cli (see .bookmarks.sample for an example)
