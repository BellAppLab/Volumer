# Volumer

A Swifty way to take control over the volume buttons on iOS.

_v0.2.0_

## Usage

```swift
class ViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //Register a volume up block
        Volume.when(.up) {
            print("UP!")
        }
        
        //Register a volume down block
        Volume.down.when {
            print("Down")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
    
        //Be sure to call this when you're finished
        Volume.reset()
        
        super.viewDidDisappear(animated)
    }

}
```

## Requirements

- iOS 8+
- MediaPlayer.framework
- **NO AVFoundation** \o/

## Installation

### Cocoapods

Because of [this](http://stackoverflow.com/questions/39637123/cocoapods-app-xcworkspace-does-not-exists), I've dropped support for Cocoapods on this repo. I cannot have production code rely on a dependency manager that breaks this badly. 

### Git Submodules

**Why submodules, you ask?**

Following [this thread](http://stackoverflow.com/questions/31080284/adding-several-pods-increases-ios-app-launch-time-by-10-seconds#31573908) and other similar to it, and given that Cocoapods only works with Swift by adding the use_frameworks! directive, there's a strong case for not bloating the app up with too many frameworks. Although git submodules are a bit trickier to work with, the burden of adding dependencies should weigh on the developer, not on the user. :wink:

To install Volumer using git submodules:

```
cd toYourProjectsFolder
git submodule add -b submodule --name Volumer https://github.com/BellAppLab/Volumer.git
```

**Swift 2 support**

```
git submodule add -b swift2 --name BLLogger https://github.com/BellAppLab/BLLogger.git
```

Then, navigate to the new Volumer folder and drag the `Source` folder to your Xcode project.

## Author

Bell App Lab, apps@bellapplab.com

## License

Volumer is available under the MIT license. See the LICENSE file for more info.
