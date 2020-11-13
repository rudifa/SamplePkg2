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

