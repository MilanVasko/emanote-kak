declare-option str emanote_popup_selector_program

define-command -docstring '
	Creates a new note and opens it.

	You can optionally specify a name for the note. Otherwise, the current date
	will be used.
' -params ..1 emanote-new %{ evaluate-commands %sh{
	if [ -z "$1" ]; then
		filename="$(date '+%Y-%m-%dT%H-%M-%S-%m-%N').md"
	else
		filename="$1.md"
	fi

	formatted_date="$(date '+%Y-%m-%dT%H:%M')"
	if [ -e "$filename" ]; then
		printf "fail \"File '$filename' already exists.\""
		exit 1
	fi
	printf "edit %s" "$filename;"
	printf "execute-keys -client \"%s\" \"i---<ret>date: $formatted_date<ret>---<ret><ret>#<esc>\";" "$kak_client"
	printf "write"
} }

define-command -docstring '
	Performs an interactive search for titles.
	Whatever file is selected will be opened.
' emanote-search-and-open %{ evaluate-commands %sh{
	if ! command -v "$kak_opt_emanote_popup_selector_program" 2>&1 > /dev/null; then
		printf "fail \"Option 'kak_opt_emanote_popup_selector_program' must be set to a valid non-empty value.\""
		exit 1
	fi

	selected_file="$(rg "^#( |\b)" --glob "**/*.md" --max-count 1 | sed 's/\([^:#]*\):#\s*\(.*\)/\2 (\1)/g' | $kak_opt_emanote_popup_selector_program | sed 's/.*(//g' | sed 's/.$//g')"
	if [ -n "$selected_file" ]; then
		printf "evaluate-commands -client \"%s\" edit \"%s\"" "$kak_client" "$selected_file"
	fi
} }

define-command -docstring '
	Performs an interactive search through all content.
	Whatever file is selected will be opened.
' emanote-search-all-and-open %{ evaluate-commands %sh{
	if ! command -v "$kak_opt_emanote_popup_selector_program" 2>&1 > /dev/null; then
		printf "fail \"Option 'kak_opt_emanote_popup_selector_program' must be set to a valid non-empty value.\""
		exit 1
	fi

	selected_file="$(rg "^.+\$" --glob "**/*.md" | sed 's/\([^:]*\):\(.*\)/\2 (\1)/g' | $kak_opt_emanote_popup_selector_program | sed 's/.*(//g' | sed 's/.$//g')"
	if [ -n "$selected_file" ]; then
		printf "evaluate-commands -client \"%s\" edit \"%s\"" "$kak_client" "$selected_file"
	fi
} }

define-command -docstring '
	Performs an interactive search for titles.
	Whatever file is selected, its ID will be inserted into the current cursor position.

	It accepts two optional parameters - the prefix and suffix used while inserting the ID.
	This is useful for specifying the kind of connection to use. Some examples:

		# this inserts a regular link
		: emanote-search-and-insert [[ ]]

		# this inserts a parent link
		: emanote-search-and-insert #[[ ]]

		# this inserts a child link
		: emanote-search-and-insert [[ ]]#
' -params ..2 emanote-search-and-insert %{ evaluate-commands %sh{
	if ! command -v "$kak_opt_emanote_popup_selector_program" 2>&1 > /dev/null; then
		printf "fail \"Option 'kak_opt_emanote_popup_selector_program' must be set to a valid non-empty value.\""
		exit 1
	fi

	selected_file="$(rg "^#( |\b)" --glob "**/*.md" --max-count 1 | sed 's/\([^:#]*\):#\s*\(.*\)/\2 (\1)/g' | $kak_opt_emanote_popup_selector_program | sed 's/.*(//g' | sed 's/\.md)$//g')"
	if [ -n "$selected_file" ]; then
	    printf "execute-keys -client \"%s\" \"i%s%s%s<esc>\"" "$kak_client" "$1" "$selected_file" "$2"
	fi
} }

define-command -docstring '
	Performs an interactive search through all content.
	Whatever file is selected, its ID will be inserted into the current cursor position.

	It accepts two optional parameters - the prefix and suffix used while inserting the ID.
	This is useful for specifying the kind of connection to use. Some examples:

		# this inserts a regular link
		: emanote-search-all-and-insert [[ ]]

		# this inserts a parent link
		: emanote-search-all-and-insert #[[ ]]

		# this inserts a child link
		: emanote-search-all-and-insert [[ ]]#
' -params ..2 emanote-search-all-and-insert %{ evaluate-commands %sh{
	if ! command -v "$kak_opt_emanote_popup_selector_program" 2>&1 > /dev/null; then
		printf "fail \"Option 'kak_opt_emanote_popup_selector_program' must be set to a valid non-empty value.\""
		exit 1
	fi

	selected_file="$(rg "^.+\$" --glob "**/*.md" | sed 's/\([^:]*\):\(.*\)/\2 (\1)/g' | $kak_opt_emanote_popup_selector_program | sed 's/.*(//g' | sed 's/\.md)$//g')"
	if [ -n "$selected_file" ]; then
	    printf "execute-keys -client \"%s\" \"i%s%s%s<esc>\"" "$kak_client" "$1" "$selected_file" "$2"
	fi
} }
