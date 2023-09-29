set shell := ['nu', '-c']

root := justfile_directory()
assets := root / 'assets'
docs := root / 'docs'
out-temp := assets / 'out'

# list recipes
[private]
default:
	@just --list

# generate a new example
gen-new-ex:
	let package = (open 'typst.toml' | get package); \
	open {{ docs / 'example/main.typ' }} \
		| str replace '/src/lib.typ' $'@preview/($package.name):($package.version)' \
		| save -f {{ assets / 'example.typ' }}

	mkdir {{ out-temp }}
	typst compile {{ docs / 'example/main.typ' }} {{ out-temp / 'example{n}.png' }} --root {{ root }}
	mv -f {{ out-temp / 'example02.png' }} {{ assets / 'example.png' }}
	rm -rf {{ out-temp }}

# generate the manual
gen-man: gen-new-ex
	typst compile {{ docs / 'manual.typ' }} {{ assets / 'manual.pdf' }} --root {{ root }}

# generate README
gen-docs: gen-new-ex
	open {{ docs / 'README-template.md' }} \
		| str replace '{example}' (open assets/example.typ) \
		| save -f README.md

# get the manual and updated docs
gen: gen-man gen-docs
