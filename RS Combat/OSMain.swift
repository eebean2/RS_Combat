//
//  OSMain.swift
//  RS Combat
//
//  Created by Erik Bean on 2/8/17.
//  Copyright © 2017 Erik Bean. All rights reserved.
//

import UIKit
import GoogleMobileAds

class OSMain: UIViewController, UITextFieldDelegate {

// Static Get Levels
    @IBOutlet var staticAttack: UILabel!
    @IBOutlet var staticStrength: UILabel!
    @IBOutlet var staticDefence: UILabel!
    @IBOutlet var staticMagic: UILabel!
    @IBOutlet var staticRange: UILabel!
    @IBOutlet var staticPrayer: UILabel!
    @IBOutlet var staticHP: UILabel!

// Get Level TextFields
    @IBOutlet var attackIn: UITextField!
    @IBOutlet var strengthIn: UITextField!
    @IBOutlet var defenceIn: UITextField!
    @IBOutlet var magicIn: UITextField!
    @IBOutlet var rangeIn: UITextField!
    @IBOutlet var prayerIn: UITextField!
    @IBOutlet var hpIn: UITextField!

// Static Set Levels
    @IBOutlet var staticSetAttack: UILabel!
    @IBOutlet var staticSetStrength: UILabel!
    @IBOutlet var staticSetDefence: UILabel!
    @IBOutlet var staticSetMagic: UILabel!
    @IBOutlet var staticSetRange: UILabel!
    @IBOutlet var staticSetPrayer: UILabel!
    @IBOutlet var staticSetHP: UILabel!

// Set Level Labels
    @IBOutlet var attackOut: UILabel!
    @IBOutlet var strengthOut: UILabel!
    @IBOutlet var defenceOut: UILabel!
    @IBOutlet var magicOut: UILabel!
    @IBOutlet var rangeOut: UILabel!
    @IBOutlet var prayerOut: UILabel!
    @IBOutlet var hpOut: UILabel!

// Other
    @IBOutlet var button: UIButton!
    @IBOutlet var scroll: UIScrollView!
    @IBOutlet var currentLevel: UILabel!
    @IBOutlet var currentStatic: UILabel!
    @IBOutlet var nextLevel: UILabel!
    @IBOutlet var nextStatic: UILabel!
    @IBOutlet var needStatic: UILabel!

// Variable Management
    var calculated = false
    var activeField: UITextField? = nil
    var lvl: Int = 0
    var fightTitle: FightTitle!
    var attack: Int {
        if attackIn.text != "" {
            return Int(attackIn.text!)!
        } else {
            return 1
        }
    }
    var strength: Int {
        if strengthIn.text != "" {
            return Int(strengthIn.text!)!
        } else {
            return 1
        }
    }
    var defence: Int {
        if defenceIn.text != "" {
            return Int(defenceIn.text!)!
        } else {
            return 1
        }
    }
    var magic: Int {
        if magicIn.text != "" {
            return Int(magicIn.text!)!
        } else {
            return 1
        }
    }
    var range: Int {
        if rangeIn.text != "" {
            return Int(rangeIn.text!)!
        } else {
            return 1
        }
    }
    var prayer: Int {
        if prayerIn.text != "" {
            return Int(prayerIn.text!)!
        } else {
            return 1
        }
    }
    var hp: Int {
        if hpIn.text != "" {
            return Int(hpIn.text!)!
        } else {
            return 10
        }
    }

// melee = floor(0.25(Defence + Hits + floor(Prayer/2)) + 0.325(Attack + Strength))
    
    var sumPrayer: Float {
        return floor(Float(prayer / 2))
    }
    var base: Float {
        return (Float(defence) + Float(hp) + sumPrayer) / 4
    }
    var warrior: Float {
        return (Float(attack) + Float(strength)) * 0.325
    }
    var ranger: Float {
        return floor(Float(range) * 1.5) * 0.325
    }
    var mage: Float {
        return floor(Float(magic) * 1.5) * 0.325
    }

// View Setup, Destruction, and Keyboard Management

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: .UIKeyboardDidHide, object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        button.layer.cornerRadius = 5
        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "768osBackground.png"))
        if UIDevice().model == "iPad" {
            visible()
            calcuate(self)
        }
        let dv = UIToolbar()
        dv.sizeToFit()
        let db = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePressed))
        dv.setItems([db], animated: false)
        attackIn.inputAccessoryView = dv
        strengthIn.inputAccessoryView = dv
        defenceIn.inputAccessoryView = dv
        magicIn.inputAccessoryView = dv
        rangeIn.inputAccessoryView = dv
        prayerIn.inputAccessoryView = dv
        hpIn.inputAccessoryView = dv
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        scroll.addGestureRecognizer(tap)
        let bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        bannerView.adUnitID = "ca-app-pub-9515262034988468/4212206831"
        bannerView.rootViewController = self

        view.addSubview(bannerView)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: bannerView, attribute: .bottom, relatedBy: .equal, toItem: scroll, attribute: .bottom, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: bannerView, attribute: .bottom, relatedBy: .equal, toItem: scroll, attribute: .bottom, multiplier: 1, constant: 0))

        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        bannerView.load(request)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardDidHide, object: nil)
    }

    @objc func keyboardDidShow(_ sender: Notification) {
        if let userInfo = sender.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                let buttonOrigin = activeField!.frame.origin
                let buttonHeight = activeField!.frame.size.height
                var visibleRect = view.frame
                visibleRect.size.height -= keyboardSize.height

                if !visibleRect.contains(buttonOrigin) {
                    let scrollPoint = CGPoint(x: 0, y: buttonOrigin.y - visibleRect.size.height + buttonHeight)
                    scroll.setContentOffset(scrollPoint, animated: true)
                }
            } else {
                print("Scroll Error! No Keyboard Data")
            }
        } else {
            print("Scroll Error! No Notification Information")
        }
    }

    @objc func keyboardDidHide(_ sender: Notification) {
        scroll.setContentOffset(CGPoint.zero, animated: true)
    }

    @objc func donePressed(_ sender: UIBarButtonItem) {
        view.endEditing(true)
    }

    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        if activeField != nil {
            activeField!.resignFirstResponder()
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }

// View Management

    @IBAction func buttonDidPress(_ sender: UIButton) {
        if !calculated { calcuate(sender) }
        visible()
        staticAttack.isHidden = !staticAttack.isHidden
        staticStrength.isHidden = !staticStrength.isHidden
        staticDefence.isHidden = !staticDefence.isHidden
        staticMagic.isHidden = !staticMagic.isHidden
        staticRange.isHidden = !staticRange.isHidden
        staticPrayer.isHidden = !staticPrayer.isHidden
        staticHP.isHidden = !staticHP.isHidden
        attackIn.isHidden = !attackIn.isHidden
        strengthIn.isHidden = !strengthIn.isHidden
        defenceIn.isHidden = !defenceIn.isHidden
        magicIn.isHidden = !magicIn.isHidden
        rangeIn.isHidden = !rangeIn.isHidden
        prayerIn.isHidden = !prayerIn.isHidden
        hpIn.isHidden = !hpIn.isHidden
        if button.currentTitle == "Calculate" {
            button.setTitle("Done", for: .normal)
        } else {
            button.setTitle("Calculate", for: .normal)
        }
    }

    func visible() {
        staticSetAttack.isHidden = !staticSetAttack.isHidden
        staticSetStrength.isHidden = !staticSetStrength.isHidden
        staticSetDefence.isHidden = !staticSetDefence.isHidden
        staticSetMagic.isHidden = !staticSetMagic.isHidden
        staticSetRange.isHidden = !staticSetRange.isHidden
        staticSetPrayer.isHidden = !staticSetPrayer.isHidden
        staticSetHP.isHidden = !staticSetHP.isHidden
        attackOut.isHidden = !attackOut.isHidden
        strengthOut.isHidden = !strengthOut.isHidden
        defenceOut.isHidden = !defenceOut.isHidden
        magicOut.isHidden = !magicOut.isHidden
        rangeOut.isHidden = !rangeOut.isHidden
        prayerOut.isHidden = !prayerOut.isHidden
        hpOut.isHidden = !hpOut.isHidden
        needStatic.isHidden = !needStatic.isHidden
        currentLevel.isHidden = !currentLevel.isHidden
        currentStatic.isHidden = !currentStatic.isHidden
        nextLevel.isHidden = !nextLevel.isHidden
        nextStatic.isHidden = !nextStatic.isHidden
    }

// Combact Calculation

    @IBAction func calcuate(_ sender: AnyObject) {
        if !calculated { calculated = true }
        if floor(warrior + base) > floor(ranger + base) && floor(warrior + base) > floor(mage + base) {
            lvl = Int(base + warrior)
            fightTitle = .melee
        } else if floor(ranger + base) > floor(warrior + base) && floor(ranger + base) > floor(mage + base) {
            lvl = Int(base + ranger)
            fightTitle = .range
        } else if floor(mage + base) > floor(warrior + base) && floor(mage + base) > floor(ranger + base) {
            lvl = Int(base + mage)
            fightTitle = .mage
        } else {
            if floor(warrior + base) < floor(mage + base) && floor(warrior + base) < floor(ranger + base) {
                lvl = Int(base + mage)
                fightTitle = .mage
            } else {
                lvl = Int(base + warrior)
                fightTitle = .skiller
            }
        }
        currentLevel.text = String(lvl)
        if lvl == 126 {
            nextLevel.text = "Maxed"
            nextLevel.sizeToFit()
        } else {
            nextLevel.text = String(lvl + 1)
        }

// Attack
        var i: Int = 1
        var c: Int = 0
        var temp: Int = attack
        if temp == 99 {
            attackOut.text = "-"
        } else {
            while i <= lvl {
                temp += 1
                let a = (Float(temp) + Float(strength)) * 0.325
                i = Int(base + a)
                c += 1
                if i > lvl {
                    if c > (99 - attack) {
                        attackOut.text = "-"
                    } else {
                        attackOut.text = String(c)
                    }
                }
            }
        }

// Strength
        i = 1
        c = 0
        temp = strength
        if temp == 99 {
            strengthOut.text = "-"
        } else {
            while i <= lvl {
                temp += 1
                let a = (Float(temp) + Float(attack)) * 0.325
                i = Int(base + a)
                c += 1
                if i > lvl {
                    if c > (99 - strength) {
                        strengthOut.text = "-"
                    } else {
                        strengthOut.text = String(c)
                    }
                }
            }
        }

// Defence
        i = 1
        c = 0
        temp = defence
        if temp == 99 {
            defenceOut.text = "-"
        } else {
            while i <= lvl {
                temp += 1
                let a = (Float(temp) + Float(hp) + sumPrayer) / 4
                switch fightTitle! {
                case .melee, .skiller:
                    i = Int(a + warrior)
                case .range:
                    i = Int(a + ranger)
                case .mage:
                    i = Int(a + mage)
                }
                c += 1
                if i > lvl {
                    if c > (99 - defence) {
                        defenceOut.text = "-"
                    } else {
                        defenceOut.text = String(c)
                    }
                }
            }
        }

// Magic
        i = 1
        c = 0
        temp = magic
        if temp == 99 {
            magicOut.text = "-"
        } else {
            while i <= lvl {
                temp += 1
                let a = Float(Int(Float(temp) * 1.5)) * 0.325
                i = Int(base + a)
                c += 1
                if i > lvl {
                    if c > (99 - magic) {
                        magicOut.text = "-"
                    } else {
                        magicOut.text = String(c)
                    }
                }
            }
        }

// Range
        i = 1
        c = 0
        temp = range
        if temp == 99 {
            rangeOut.text = "-"
        } else {
            while i <= lvl {
                temp += 1
                let a = Float(Int(Float(temp) * 1.5)) * 0.325
                i = Int(base + a)
                c += 1
                if i > lvl {
                    if c > (99 - range) {
                        rangeOut.text = "-"
                    } else {
                        rangeOut.text = String(c)
                    }
                }
            }
        }

// Prayer
        i = 1
        c = 0
        temp = prayer
        if temp == 99 {
            prayerOut.text = "-"
        } else {
            while i <= lvl {
                temp += 1
                let a = (Float(Int(temp / 2)) + Float(defence) + Float(hp)) / 4
                switch fightTitle! {
                case .melee, .skiller:
                    i = Int(a + warrior)
                case .range:
                    i = Int(a + ranger)
                case .mage:
                    i = Int(a + mage)
                }
                c += 1
                if i > lvl {
                    if c > (99 - prayer) {
                        prayerOut.text = "-"
                    } else {
                        prayerOut.text = String(c)
                    }
                }
            }
        }
        
// HP
        i = 1
        c = 0
        temp = hp
        if temp == 99 {
            hpOut.text = "-"
        } else {
            while i <= lvl {
                temp += 1
                let a = (Float(defence) + Float(temp) + sumPrayer) / 4
                switch fightTitle! {
                case .melee, .skiller:
                    i = Int(a + warrior)
                case .range:
                    i = Int(a + ranger)
                case .mage:
                    i = Int(a + mage)
                }
                c += 1
                if i > lvl {
                    if c > (99 - hp) {
                        hpOut.text = "-"
                    } else {
                        hpOut.text = String(c)
                    }
                }
            }
        }
    }
}
