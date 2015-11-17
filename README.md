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

iOS 8+
MediaPlayer
**NO AVFoundation** \o/

## Installation

Volumer is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Volumer"
```

## Author

Bell App Lab, apps@bellapplab.com

## License

Volumer is available under the MIT license. See the LICENSE file for more info.
