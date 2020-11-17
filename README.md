# SamplePkg2

Purpose: investigate building a SPM package in Xcode and from command line.

Problems:
- in Xcode import UIKit is accepted and the corresponding unit tests pass.

- in cli, swift build fails
``` 
error: no such module 'UIKit'
import UIKit
```
Reason is that swift build builds for the macosx platform.

Question: how do I tell swift build to build for iphonesimulator platform?

### 1. main has no UIKit dependency
- add the basic build_and_test.yml: passes
- source and test code is compatible with macosx
- build and tests are performed for the default sdk, the macosx

```
name: build_and_test

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:

    runs-on: macos-latest

    steps:
    - uses: actions/checkout@v2
    - name: Build
      run: swift build -v
    - name: Run tests
      run: swift test -v
```



