import UIKit
import MediaPlayer


public enum Volume
{
    public typealias Block = () -> Void
    
    case up, down
    
    public static func when(_ kind: Volume, _ block: @escaping Block)
    {
        Volume.setup()
        var array = Volume.blocks[kind] ?? []
        array.append(block)
        Volume.blocks[kind] = array
    }
    
    public func when(block: @escaping Block)
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
            self.volumeView = MPVolumeView(frame: CGRect(x: 0,
                                                         y: -100,
                                                         width: 100,
                                                         height: 50))
            UIApplication.shared.windows.first!.addSubview(self.volumeView!)
        }
        if self.observer == nil {
            self.observer = Observer()
        }
        self.volumeView?.slider?.addTarget(self.observer,
                                           action: #selector(Observer.sliderDidChange(_:)),
                                           for: .valueChanged)
    }
    
    private static func unsetup()
    {
        if !self.hasSetup {
            return
        }
        self.hasSetup = false
        self.volumeView?.slider?.removeTarget(self.observer,
                                              action: #selector(Observer.sliderDidChange(_:)),
                                              for: .valueChanged)
        self.observer = nil
        self.volumeView.removeFromSuperview()
        self.volumeView = nil
    }
    
    //MARK: Observer Delegate
    fileprivate static func didChange(up: Bool) {
        if let tempBlocks = Volume.blocks[up.asVolume] {
            for block in tempBlocks {
                DispatchQueue.main.async {
                    block()
                }
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
        NotificationCenter.default.removeObserver(self)
    }
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(Observer.willBecomeInactive(_:)),
                                               name: .UIApplicationWillResignActive,
                                               object: nil)
    }
    
    @objc fileprivate func sliderDidChange(_ sender: UISlider) {
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
            Volume.didChange(up: sender.value == 1.0)
        } else {
            Volume.didChange(up: sender.value > self.initialValue)
        }
        if Volume.keepIntact {
            notify = false
            sender.value = self.initialValue
        }
    }
    
    @objc fileprivate func willBecomeInactive(_ notification: NSNotification) {
        activationCount = 1
        self.initialValue = nil
    }
}

private extension MPVolumeView
{
    var slider: UISlider? {
        return self.subviews.first(where: { $0 is UISlider }) as? UISlider
    }
}

private extension Bool
{
    var asVolume: Volume {
        return self ? .up : .down
    }
}

