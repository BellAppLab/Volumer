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
    
    public static func setup()
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
    
    public static func unsetup()
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
    private var currentValue: Float?
    private var notify = true
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(Observer.willBecomeInactive(_:)),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
    }
    
    @objc fileprivate func sliderDidChange(_ sender: UISlider) {
        if currentValue == nil {
            currentValue = sender.value
            return
        }
        if !notify {
            notify = true
            return
        }
        if sender.value == currentValue {
            return
        }
        Volume.didChange(up: sender.value > currentValue!)
        currentValue = sender.value
        if Volume.keepIntact {
            notify = false
            sender.value = currentValue!
        }
    }
    
    @objc fileprivate func willBecomeInactive(_ notification: NSNotification) {
        currentValue = nil
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
