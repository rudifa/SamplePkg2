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

### 1. main has no UIKit dependency : add action build_and_test.yml
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

### 2. modify action build_and_test.yml to run xcodebuild -sdk iphonesimulator
- build succeeds and tests pass

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
    #- name: Build
    #  run: swift build -v
    #- name: Run tests
    #  run: swift test -v
    - name: xcodebuild test
      run: xcodebuild test -scheme SamplePkg2 -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 11 Pro,OS=latest' -verbose
```

### 3. branch using-uikit-2: add UIKit dependency and unit tests; merge into main
- build succeeds and tests pass

