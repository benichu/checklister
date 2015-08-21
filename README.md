# Checklister

> STILL UNDER ACTIVE DEVELOPMENT, NOT RELEASED YET

[![Build Status](https://travis-ci.org/benichu/checklister.svg)](https://travis-ci.org/benichu/checklister)
[![Dependency Status](https://gemnasium.com/benichu/checklister.svg)](https://gemnasium.com/benichu/checklister)
[![Gem Version](https://badge.fury.io/rb/checklister.svg)](http://badge.fury.io/rb/checklister)
[![Code Climate](https://codeclimate.com/github/benichu/checklister/badges/gpa.svg)](https://codeclimate.com/github/benichu/checklister)
[![Coverage Status](https://coveralls.io/repos/benichu/checklister/badge.svg?branch=master&service=github)](https://coveralls.io/github/benichu/checklister?branch=master)

## Description

Checklister is a CLI packaged as a Ruby gem giving you the power to transform any markdown file or url checklist into an actionable gitlab (and soon github) issue.

### Why using checklists

A checklist is an ideal tool to help people remembering all of the steps required to accomplish complicated tasks and objectives.
Using a checklist enforces best practices, even if they seem obvious at first, preventing costly mistakes.

### The Checklist Manifesto

A great book to read for more inspiration about the power of checklist:

![The Checklist Manifesto](http://atulgawande.com/wp-content/uploads/2013/11/71CwWiCJhuL-319x479.jpg)

Source: http://atulgawande.com/book/the-checklist-manifesto/

## Usage

### Requirements

* Ruby 2.0+
* RubyGems 1.9+
* a Gitlab and/or Github user authentication token

### Install/Update gem

    TO RELEASE

### Setup Gitlab Authentication

```bash
$ checklister setup gitlab
```

### Setup Github Authentication

```bash
$ checklister setup github
```

### CLI

```bash
$ checklister --file https://raw.githubusercontent.com/benichu/checklister/master/examples/simple-checklist.md \
              --new_issue_url https://github.com/benichu/checklister/issues
```

The initial markdown file at `https://raw.githubusercontent.com/benichu/checklister/master/examples/simple-checklist.md` is the following :

    INSERT SCREENSHOT HERE

Once the file is parsed, an issue will be created with its content. In this case, the issue would be :

    INSERT SCREENSHOT HERE

## Development Setup

### Dependencies

* rbenv or rvm
* Ruby 2.0+
* RubyGems 1.9+ (`gem update --system `)
* Bundler 1.10+

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

    Make sure you are all setup first: http://guides.rubygems.org/publishing/#publishing-to-rubygemsorg

To prepare a release, run `script/release`. This will package a new version of the `checklister` gem and release it to [https://rubygems.org/gems/checklister](https://rubygems.org/gems/checklister).

## Roadmap

### Version 1.0

- [ ] Create a new Issue based on a specific markdown file (remote or local path)
- [ ] Connect to gitlab account
- [ ] Connect to github account

### Wishlist

- [ ] Select a milestone from a list populated based on github/gitlab API
- [ ] Select a checklist from an history list

## Authors

Checklister is written and maintained by [Benjamin Thouret](https://github.com/benichu) and [Manon Deloupy](https://github.com/mdeloupy).

## License

[Checklister is licensed under the MIT License](LICENSE)
