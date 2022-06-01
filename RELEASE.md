# Releasing a new version of octopoller.rb

1. Create a list of all the changes since the prior release
    1. Compare the previous release to `master` using `https://github.com/octokit/octopoller.rb/compare/`v1.3.3.7...master` (assuming that the last release was `v1.3.3.7`)
1. Ensure there are no breaking changes _(if there are breaking changes you'll need to create a release branch without those changes or bump the major version)_
1. Update the version
    1. Checkout `master`
    1. Update the constant in `lib/octopoller/version.rb` (when `bundle` is executed the version in the `Gemfile.lock` will be updated)
    1. Run `bin/setup` so that `Gemfile.lock` will be updated with the new version
    1. Commit and push directly to `master`
1. Run the `script/release` script to cut a release
1. Draft a new release at <https://github.com/octokit/octopoller.rb/releases/new> containing the changelog from step 1

## Prerequisites

In order to create a release, you will need to be an owner of the octopoller gem on Rubygems.

Verify with:
```
gem owner octopoller
```

An existing owner can add new owners with:
```
gem owner octopoller --add EMAIL
```
