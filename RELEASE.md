# Releasing a new version of octopoller.rb

1. Create a list of all the changes since the prior release
    1. Compare the previous release to `master` using `https://github.com/octokit/octopoller.rb/compare/`v1.3.3.7...master` (assuming that the last release was `v1.3.3.7`)
2. Ensure there are no breaking changes _(if there are breaking changes you'll need to create a release branch without those changes or bump the major version)_
3. Update the version
    1. Checkout `master`
    2. Update the constant in `lib/octopoller/version.rb` (when `bundle` is executed the version in the `Gemfile.lock` will be updated)
    3. Run `bin/setup` so that `Gemfile.lock` will be updated with the new version
    4. Commit and push directly to `master`
4. Run the "File integrity check"
5. Run the `script/release` script to cut a release
6. Draft a new release at <https://github.com/octokit/octopoller.rb/releases/new> containing the changelog from step 1

----

## File integrity check

(Given octopoller.rb is currently shipped "manually")

Because different environments behave differently, it is recommended that the integrity and file permissions of the files packed in the gem are verified. This is to help prevent things like releasing world writeable files in the gem. As we get things a little more automated, this will become unnecessary.

Until then, it is recommended that if you are preparing a release you run the following prior to releasing the gem:

From the root of octopoller.rb

```
> gem build *.gemspec
```

Use the version from the build in the next commands

```
> tar -x -f octopoller-#.##.#.gem 
> tar -t -v --numeric-owner -f data.tar.gz |head -n 10
```

The files in the output should have the following permessions set:  
`-rw-r--r--`

(optional) Once verified, you can run `git clean -dfx` to clean things up before packing 

----

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
