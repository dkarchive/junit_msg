# junit_msg

Simple message formatter for JUnit XML files :speech_balloon:

[![CircleCI](https://img.shields.io/circleci/project/github/dkhamsing/junit_msg.svg)]()

## Installation

```bash
git clone https://github.com/dkhamsing/junit_msg
cd junit_msg
rake install
```

## Usage

```sh
 junit_msg <junit file> <message>
       format message with specifiers:
         !jmt 	 Total number of tests
         !jme 	 Number of tests with errors
         !jmf 	 Number of tests failing
         !jms 	 Number of tests skipped
         !jmp 	 Number of tests passing
         !jmnp 	 Number of tests not passing
```

### Examples

```sh
# default message (all equivalent):
$ junit_msg junit.xml --default
$ junit_msg junit.xml -d
$ junit_msg junit.xml '!jmp tests passing out of !jmt'
56 tests passing out of 58
```

```sh
$ junit_msg junit.xml 'Tests: !jmt with !jmp passing and !jmf failing'
Tests: 22 passing and 2 failing
```

### CI / Jenkins

```sh
# Run tests and generate junit.xml
...

RESULTS=$(junit_msg build/reports/junit.xml 'Tests: !jmt with !jmp passing and !jmf failing')

# Post message to Slack
curl -d 'payload={"channel":"#ci","username":"ci-test","icon_emoji":":construction:","text":"'"$RESULTS"'"}' $SLACK_URL

# Post comment to GitHub pull request
curl -d '{"body":"'"$RESULTS"'"}' -u $GIT_USER:$GIT_TOKEN $GIT_COMMENT_URL
```

## Credits

If you ever wished you could use [`danger-junit`](https://github.com/orta/danger-junit) but without Danger.

## Contact

- [github.com/dkhamsing](https://github.com/dkhamsing)
- [twitter.com/dkhamsing](https://twitter.com/dkhamsing)

## License

This project is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
