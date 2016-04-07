# Volumer

[![CI Status](http://img.shields.io/travis/Bell App Lab/Volumer.svg?style=flat)](https://travis-ci.org/Bell App Lab/Volumer)
[![Version](https://img.shields.io/cocoapods/v/Volumer.svg?style=flat)](http://cocoapods.org/pods/Volumer)
[![License](https://img.shields.io/cocoapods/l/Volumer.svg?style=flat)](http://cocoapods.org/pods/Volumer)
[![Platform](https://img.shields.io/cocoapods/p/Volumer.svg?style=flat)](http://cocoapods.org/pods/Volumer)

## Usage

```swift
import UIKit
import Volumer

class ViewController: UIViewController {

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        //Use this if you want the volume buttons to still affect the device's playback volume
        //The default is `true`
        Volume.keepIntact = false

        //Use your own MPVolumeView if you want
        //Obs. This method needs to be executed if you have called `Volume.reset()`
        Volume.use(self.volumeView)

        //Register a volume up block
        Volume.when(.Up) {
            print("UP!")
        }

        //Register a volume down block
        Volume.Down.when {
            print("Down")
        }
    }

    override func viewDidDisappear(animated: Bool) {

        //Be sure to call this when you're done
        Volume.reset()

        super.viewDidDisappear(animated)
    }

}
```

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- iOS 8+
- MediaPlayer
- **NO AVFoundation** \o/

## Installation

### CocoaPods

Volumer is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Volumer"
```

### Git Submodules

**Why submodules, you ask?**

Following [this thread](http://stackoverflow.com/questions/31080284/adding-several-pods-increases-ios-app-launch-time-by-10-seconds#31573908) and other similar to it, and given that Cocoapods only works with Swift by adding the use_frameworks! directive, there's a strong case for not bloating the app up with too many frameworks. Although git submodules are a bit trickier to work with, the burden of adding dependencies should weigh on the developer, not on the user. :wink:

To install Volumer using git submodules:

```
cd toYourProjectsFolder
git submodule add -b Submodule --name Volumer https://github.com/BellAppLab/Alertable.git
```

Navigate to the new Volumer folder and drag the Pods folder to your Xcode project.

## Author

Bell App Lab, apps@bellapplab.com

## License

Volumer is available under the MIT license. See the LICENSE file for more info.
