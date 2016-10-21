# HardTest
An open source analog/mixed-signal test suite.


## Concept
We're building a Unified API for interacting with devices common when testing analog & mixed-signal systems. With a well-defined set of interfaces, it becomes possible to build truly reusable (and reproducable!) test methods, so you can spend more time on what's important: your hardware.



## Installation
1. Clone the repo to a convenient directory (ex. `$ git clone git@github.com:johnlb/ht.git ~/Documents/MATLAB/ht`)
2. If it doesn't exist, create a file called `~/Documents/MATLAB/startup.m`
3. Append the following line to `startup.m`:
```
addpath('path\to\ht\matlab')
```
4. Restart Matlab. ht's packages should now be available.


## Contributing

[Grabbed from thoughtbot for now. Will write a custom one soon.]

We love contributions from everyone.
By participating in this project,
you agree to abide by the thoughtbot [code of conduct].

  [code of conduct]: https://thoughtbot.com/open-source-code-of-conduct

We expect everyone to follow the code of conduct
anywhere in thoughtbot's project codebases,
issue trackers, chatrooms, and mailing lists.

### Contributing Code

$(INSTALL_DEPENDENCIES)

Fork the repo.

Make sure the tests pass:

    $(TEST_RUNNER)

Make your change, with new passing tests. Follow the [style guide][style].

  [style]: https://github.com/thoughtbot/guides/tree/master/style

Mention how your changes affect the project to other developers and users in the
`NEWS.md` file.

Push to your fork. Write a [good commit message][commit]. Submit a pull request.

  [commit]: http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html

Others will give constructive feedback.
This is a time for discussion and improvements,
and making the necessary changes will be required before we can
merge the contribution.