# emanote-kak

This repository contains useful commands for interacting with an
[emanote](https://emanote.srid.ca) repository.

## Requirements

The following utilities are used, so make sure you have them installed and in
`PATH`:

- `date`
- [`rg`](https://github.com/BurntSushi/ripgrep) (support for other similar tools
  currently not planned, but PRs are welcome)
- `sed`
- Any [`dmenu`](https://tools.suckless.org/dmenu/)-like utility (I recommend
  [`rofi`](https://github.com/davatorium/rofi) or
  [`bemenu`](https://github.com/Cloudef/bemenu), which I'm currently using). It
  needs to be able to do the following:
	- take input from `stdin`
	- print the selected option to `stdout`
	- print nothing if the selection was aborted

Note that there's no dependency on the `emanote` binary itself, so you can use
this plugin in other contexts as well (say, [`neuron`](https://neuron.zettel.page)
or any other kind of directory with Markdown files). Just note that supporting
`emanote` will be a priority for possible further development.

## Installing and configuring

The recommended approach is to use [plug.kak](https://github.com/andreyorst/plug.kak)
for installing this plugin.

The snippet below shows how to install the plugin and also contains the
recommended configuration (AKA how I personally use it).

```kak
plug "MilanVasko/emanote-kak" config %{
	# the following is a recommended configuration

	declare-user-mode emanote
	# you need to specify a menu program to filter the notes
	set-option global emanote_popup_selector_program "bemenu"
	map global emanote n -docstring "create new note with random ID"   ": emanote-new<ret>"
	map global emanote N -docstring "create new note"                  ": emanote-new "
	map global emanote s -docstring "search titles and open note"      ": emanote-search-and-open<ret>"
	map global emanote S -docstring "search all and open note"         ": emanote-search-all-and-open<ret>"
	map global emanote i -docstring "search titles and insert note ID" ": emanote-search-and-insert [[ ]]<ret>"
	map global emanote I -docstring "search all and insert note ID"    ": emanote-search-all-and-insert [[ ]]<ret>"
}
```

## Functionality

The following commands are provided:

- `emanote-new` - creates a new note
- `emanote-search-and-open` - searches for notes interactively
- `emanote-search-and-insert` - inserts the note ID of found note into the
  document

More commands may come in the future if I get ideas for new ones - all of the
existing ones have their origins in my personal need. For now, these should be
enough to make the most common tasks easier.

## Contributing

If you'd like to contribute, please do! There are no hard rules to follow, just
create an issue or a pull request and I'll try to get back to you.

