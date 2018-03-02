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

Installation
------------

```sh
git clone https://github.com/TimWSpence/bookmarks.git ~/dev/bookmarks
cd ~/dev/bookmarks
bundle
./bm --help
```

You might want to consider adding this directory to your path (in .bashrc, etc):
` export PATH=$PATH:$HOME/dev/bookmarks `
to enable usage from anywhere as `bm --help`
