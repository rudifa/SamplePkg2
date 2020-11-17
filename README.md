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

### 4. add .jazzy.yaml

- this file instructs jazzy to use xcodebuild with sdk iphonesimulator
- this enables jazzy documenting code that depends on UIKit (or other non-macosx frameworks) 
```
clean: true
swift_build_tool:
  xcodebuild
xcodebuild_arguments:
  - -verbose  # no effect
  - -scheme
  - SamplePkg2
  - -sdk
  - iphonesimulator
author: Rudi Farkas
copyright: Copyright © 2019 Rudi Farkas. All rights reserved.
min_acl: internal
```

### 5. add build_jazzy_docs.yml

- this builds the jazzy docs and publishes them via gh-pages:
[SamplePkg2](https://rudifa.github.io/SamplePkg2/docs/)

```
name: build_jazzy_docs

on:
  push:
    branches: [ master ]
  pull_request:
    branches: [ master ]
  workflow_dispatch:
    branches: [ master ]
    
jobs:
  build:

    runs-on: macos-latest

    steps:
    - uses: actions/checkout@v2

    - name: echo $GITHUB_SHA
      run: echo $GITHUB_SHA

    - name: git fetch --all
      run: git fetch --all

    - name: git log -1 --oneline 
      run: git log -1 --oneline

    - name: git checkout gh-pages
      run: git checkout gh-pages

    - name: git reset --hard $GITHUB_SHA
      run: git reset --hard $GITHUB_SHA

    - name: install jazzy
      run: gem install jazzy --no-document

    - name: build jazzy docs on gh-pages
      run: jazzy

    - name: git add .
      run: git add .

    - name: git commit -m "update jazzy docs"
      run: git commit -m "update jazzy docs"

    - name: git push --force
      run: git push --force
 
    - name: git checkout main
      run: git checkout main
```

