### UI Testing Suite for Github.com

These are merely examples and me sharpening my ruby/BDD skills. I'm using the following:

* [cucumber/gherkin for BDD](https://github.com/cucumber/cucumber)
* [site_prism to keep tests dry via page objects](https://github.com/natritmeyer/site_prism)
* [capybara to interact with DOM](https://github.com/jnicklas/capybara)
* [rspec for assertions](https://github.com/rspec/rspec)

`features/support/env.rb` is the first file loaded (`cucumber` sources the support folder and it's constituent files before all others).
It is here that dependencies are loaded, `capybara` is configured, and the `to_hub` `String` extension
method is declared. I needed this because `site_prism` uses `addressable_uri` to handle uris. `addressable_uri`
uri encodes the page object's url, so values like "rails/rails", will become "rails/%<encodedvalue>rails".
I wanted to be able to use the github style syntax for repos, but in addition, needed `addressable_uri`
to output the correct url. `to_hub` splits the url, and divides it into the github user and repository name.
These two values are later fed into the `PullRequest` page object.

### But I Want To Go Headless

Feel free to use whatever driver you like. If I haven't already configured `capybara` to use `phantom/poltergeist`, it's
only because I've either forgotten to do so, or haven't gotten the tests to pass and need visible feedback. You can swap
out the driver inside `env.rb`. Just be sure you've got the correct binary installed. For example, if you want
to use the `selenium_chrome` driver that I registered in `env.rb`, you'll need to install the `chromewebdriver` binary.

On Mac, you can achieve this via Homebrew using:

```shell
brew install chromewebdriver
```

That's about it folks. I'll probably publish a `Gemfile` later so you can easily install required gems, but I
think you'll be able to figure out what you need based on runtime errors. If everything is properly installed,
then the tests should all pass.

### Directory structure

Each feature is broken down into three slices:

* `feature file` - features/**&lt;feature&gt;**/**&lt;subfeature&gt;**.feature
* `page object` - features/pages/**&lt;feature&gt;**/**&lt;subfeature&gt;**.rb
* `step file` - features/steps/**&lt;feature&gt;**/**&lt;subfeature&gt;**.rb

For example, projects/repositories can have pull requests. `Project` would be the ***feature***, and `pull request` would
be the ***sub feature***. I'm in no way, shape, or form advocating that this is ***the*** way to organize your
test code. It's just something I'm experimenting with. This would probably need another level of granularity
to account for the different actions you can take within a sub feature (`create`, `read`, `update`, `delete`), ***or not***.
It ultimately depends on the guys you're working with.

### Running the tests

I may or may not have setup a rake task to execute the tests by the time you encounter this `README.` If not,
install `cucumber` via:

```shell
gem install cucumber --no-ri --no-rdoc
```

and execute:

```shell
cd checkoutdir
cucumber --verbose
```

from the command line. The verbosity switch is obviously optional. You don't need to be inside the `features` folder
to run the tests. `cucumber` by default will scan your current directory for a folder named `features` and go to town
from there.

### Why Page Objects?

Page objects keep your tests dry. Your step definitions won't be cluttered with selectors and parsing boilerplate.
It's a good way to separate the concerns of your arrange, act, assert from the underlying DOM.
Yes, `capybara` has a beautiful DSL, but you'll inevitably need to access the same element or section of the DOM more than once,
and that's where the duplication will start to take its toll. Page objects are more than a fad or purist thing to me. They make
your code much less dependant on the structure of your DOM. Need to change your markup? Great, make the change, watch
your tests fail, and go update the ONE spot that's relying upon the css class you just swapped out  in exchange for Twitter
Bootstrap. Your tests will read much nicer, and take on a more mundane and primitive persona (again...`capybara` is awesome
but this is awesomer).

`site_prism` has an awesome DSL that makes working with page objects a breeze. Have a reusable partial that you're invoking
inside a loop server side? Great, make a section for it and you can reuse it in your page object exactly as you did server side.
This allows you to decompose your page objects to an arbitrary depth and to your heart's content (sections, within sections, etc.).
This is the approach I took for the `diffs` in the `PullRequest` page object. Github renders the same markup for each `diff`, but
dynamically switches the content. This was the perfect use case for the `DiffSection` you see inside `PullRequest`.

### Are Page Objects Ubiquitous?

I've yet to see this pattern adopted by mainstream ruby projects. Most if not all are content with using `capybara` directly; which
is great. However, page objects via `site_prism` are one step closer to greatness IMO. You can modify your DOM with far greater
conviction, further improve the readability and maintainability of your tests, and encapsulate the various aspects of each page
or section of a page in a single location (makes refactoring trivial). Do I have a problem with using pure `capybara` to write tests?
Absolutely NOT!! `capybara` is awesome and I'd gladly work with it directly on any project. Thank being said, I think page objects
are an added bonus, and allow us to speak the "ubiquitous language" of our domain even more so (among other benefits). Cheers...
