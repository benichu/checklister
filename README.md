# Checklister

[![Build Status](https://travis-ci.org/benichu/checklister.svg)](https://travis-ci.org/benichu/checklister)
[![Dependency Status](https://gemnasium.com/benichu/checklister.svg)](https://gemnasium.com/benichu/checklister)
[![Gem Version](https://badge.fury.io/rb/checklister.svg)](http://badge.fury.io/rb/checklister)
[![Code Climate](https://codeclimate.com/github/benichu/checklister/badges/gpa.svg)](https://codeclimate.com/github/benichu/checklister)
[![Coverage Status](https://coveralls.io/repos/benichu/checklister/badge.svg?branch=master&service=github)](https://coveralls.io/github/benichu/checklister?branch=master)

## Description

Checklister is a CLI packaged as a Ruby gem giving you the power to transform any markdown file or url checklist into an actionable gitlab or github issue.

### Why using checklists

A checklist is an ideal tool to help people remembering all of the steps required to accomplish complicated tasks and objectives.
Using a checklist enforces best practices, even if they seem obvious at first, preventing costly mistakes.

### The checklist manifesto

A great book to read for more inspiration about the power of checklist:

![The Checklist Manifesto](http://atulgawande.com/wp-content/uploads/2013/11/71CwWiCJhuL-319x479.jpg)

Source: http://atulgawande.com/book/the-checklist-manifesto/

## Usage

### Requirements

* Ruby 2.0+
* RubyGems 1.9+
* a Gitlab and/or Github user authentication token

#### Find your Github token

<a href="https://www.dropbox.com/s/smnc1qdklwadvzu/Github%20token.mp4?dl=0" target="_blank">Follow this video tutorial.</a>

#### Find your Gitlab token (v7)

<a href="https://www.dropbox.com/s/cob01skd1jbp2ha/Old%20Gitbal%20token.mp4?dl=0" target="_blank">Follow this video tutorial.</a>

#### Find your Gitlab token (v8)

<a href="https://www.dropbox.com/s/e12pmlk5416hlac/Gitlab%20token.mp4?dl=0" target="_blank">Follow this video tutorial.</a>

### Install/Update gem

```bash
$ gem install checklister
```

> NOTE: If you use a ruby manager, the gem have to be installed each time you want to use it in a new ruby context.

#### PROTIP

If you use rbenv as your ruby manager, and want to easily install/update `checklister` across all your rubies:

1. Install [rbenv-each](https://github.com/rbenv/rbenv-each)
1. Run `$ rbenv each gem install checklister` everytime there is a new version of the gem

### Setup Gitlab Authentication

```bash
$ checklister setup
```

Answer the questions and the information will be saved for later use in a configuration json file.

### Check your saved configuration

```bash
$ checklister settings
```

### CLI

```bash
$ checklister new --checklist /path/to/simple-checklist.md
```

In this example, the initial markdown file at `https://raw.githubusercontent.com/benichu/checklister/master/examples/simple-checklist.md` is the following :

![Simple Checklist](http://i.imgur.com/KUXThqu.png)

Once the file is parsed, a Github issue will be created with its content. In this case, the issue would be :

![Github Issue](http://i.imgur.com/1IwGKaS.png)

Alternatively, you can set a custom title for your issue with the `-t` or `--title` option :

```bash
$ checklister new --checklist /path/to/simple-checklist.md --title "A custom title"
```

## Development Setup

### Dependencies

* rbenv or rvm
* Ruby 2.0+
* RubyGems 1.9+ (`gem update --system `)
* Bundler 1.10+
* [ctags](http://ctags.sourceforge.net/)

### Bootstrap

To install or update your development environment, run `script/bootstrap`.

### Install

1. Clone the git repository: `git clone git@github.com:benichu/checklister.git`
2. Run `script/bootstrap` to install the required gems.
3. Run `script/test` to ensure your development setup is sane.
5. Read `CONTRIBUTING.md` for contribution guidelines.
6. Run `bundle exec guard`
7. You can run a REPL: `script/console`

### Testing

You can write tests using `rspec v3+` syntax in the `spec` folder. To run the tests, run `script/test`.

### Documentation

[Documenting your code from rubygems.org](http://guides.rubygems.org/make-your-own-gem/#documenting-your-code)

This project is documented with the [YARD syntax](http://www.rubydoc.info/gems/yard/file/docs/GettingStarted.md),
every time the gem is published a documentation will automatically be generated at [rubydoc.info](http://www.rubydoc.info/gems/checklister).

You should always check how your documentation looks like from time to time.
Here is a convenient way for you to run a yard server:

```bash
$ script/doc
```

You can now open your browser at [http://localhost:8808/](http://localhost:8808/)

### Release

    Make sure you are all set up first: http://guides.rubygems.org/publishing/#publishing-to-rubygemsorg

To prepare a release, run `script/release`. This will package a new version of the `checklister` gem and release it to [https://rubygems.org/gems/checklister](https://rubygems.org/gems/checklister).

## Roadmap

### Wishlist

- [ ] [documentation] Yard documentation updated
- [ ] [dev] Better step by step DSL for CLI interactions with user
- [ ] [feature] Select a milestone from a list populated based on github/gitlab API
- [ ] [feature] Select a checklist from an history list
- [ ] [feature] Connect to a bitbucket account
- [ ] [feature] Create a new Issue based on a specific markdown file (remote path)

## Authors

Checklister is written and maintained by [Benjamin Thouret](https://github.com/benichu) and [Manon Deloupy](https://github.com/mdeloupy).

## License

[Checklister is licensed under the MIT License](LICENSE)
