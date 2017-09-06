import UIKit
import MediaPlayer


public enum Volume
{
    public typealias Block = () -> Void
    
    case Up, Down
    
    public static func when(kind: Volume, _ block: Block)
    {
        Volume.setup()
        var array = Volume.blocks[kind]
        if array == nil {
            array = []
        }
        array!.append(block)
        Volume.blocks.updateValue(array!, forKey: kind)
    }
    
    public func when(block: Block)
    {
        Volume.when(self, block)
    }
    
    public static func reset() {
        Volume.blocks = [Volume: [Block]]()
        self.unsetup()
    }
    
    public static var keepIntact = true
    
    private static var blocks = [Volume: [Block]]()
    private static var hasSetup = false
    private static var volumeView: MPVolumeView!
    
    public static func use(volumeView: MPVolumeView)
    {
        self.volumeView = volumeView
    }
    
    private static var observer: Observer!
    
    private static func setup()
    {
        if self.hasSetup {
            return
        }
        self.hasSetup = true
        if self.volumeView == nil {
            self.volumeView = MPVolumeView(frame: CGRectMake(0, -100, 100, 50))
            UIApplication.sharedApplication().windows.first!.addSubview(self.volumeView!)
        }
        if self.observer == nil {
            self.observer = Observer()
        }
        if let slider = self.volumeView?.slider {
            slider.addTarget(self.observer, action: #selector(Observer.sliderDidChange(_:)), forControlEvents: .ValueChanged)
        }
    }
    
    private static func unsetup()
    {
        if !self.hasSetup {
            return
        }
        self.hasSetup = false
        if let slider = self.volumeView?.slider {
            slider.removeTarget(self.observer, action: #selector(Observer.sliderDidChange(_:)), forControlEvents: .ValueChanged)
        }
        self.observer = nil
        self.volumeView.removeFromSuperview()
        self.volumeView = nil
    }
    
    //MARK: Observer Delegate
    internal static func didChange(up: Bool) {
        if let tempBlocks = Volume.blocks[up ? .Up : .Down] {
            for block in tempBlocks {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    block()
                })
            }
        }
    }
}

@objc private class Observer: NSObject
{
    private var initialValue: Float!
    /*
        Hacky way of preventing Volumer from firing its blocks when the MPVolumeView starts (and, for some reason, fires a .ValueChanged event twice)
        Also, when moving from the background, MPVolumeView fires once more (for some reason)
    */
    private var activationCount = 2
    private var notify = true
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override init() {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(Observer.willBecomeInactive(_:)), name: UIApplicationWillResignActiveNotification, object: nil)
    }
    
    @objc private func sliderDidChange(sender: UISlider) {
        activationCount -= 1
        if activationCount > 0 {
            if self.initialValue == nil {
                self.initialValue = sender.value
            }
            return
        }
        if self.initialValue == nil {
            return
        }
        if !notify {
            notify = true
            return
        }
        if sender.value == self.initialValue {
            Volume.didChange(sender.value == 1.0)
        } else {
            Volume.didChange(sender.value > self.initialValue)
        }
        if Volume.keepIntact {
            notify = false
            sender.value = self.initialValue
        }
    }
    
    @objc private func willBecomeInactive(notification: NSNotification) {
        activationCount = 1
        self.initialValue = nil
    }
}

private extension MPVolumeView
{
    var slider: UISlider? {
        for view in self.subviews {
            if let isSlider = view as? UISlider {
                return isSlider
            }
        }
        return nil
    }
}

