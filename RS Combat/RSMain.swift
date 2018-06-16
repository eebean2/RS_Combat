//
//  RSMain.swift
//  RS Combat
//
//  Created by Erik Bean on 2/6/17.
//  Copyright © 2017 Erik Bean. All rights reserved.
//

import UIKit
import GoogleMobileAds

enum FightTitle {
    case melee
    case mage
    case range
    case skiller
}

class RSMain: UIViewController, UITextFieldDelegate {

// Static Get Levels
    @IBOutlet var staticAttack: UILabel!
    @IBOutlet var staticStrength: UILabel!
    @IBOutlet var staticDefence: UILabel!
    @IBOutlet var staticMagic: UILabel!
    @IBOutlet var staticRange: UILabel!
    @IBOutlet var staticPrayer: UILabel!
    @IBOutlet var staticSummoning: UILabel!
    @IBOutlet var staticConstitution: UILabel!

// Get Levels Textfields
    @IBOutlet var attackIn: UITextField!
    @IBOutlet var strengthIn: UITextField!
    @IBOutlet var defenceIn: UITextField!
    @IBOutlet var magicIn: UITextField!
    @IBOutlet var rangeIn: UITextField!
    @IBOutlet var prayerIn: UITextField!
    @IBOutlet var summoningIn: UITextField!
    @IBOutlet var constitutionIn: UITextField!

// Static Set Levels
    @IBOutlet var staticSetAttack: UILabel!
    @IBOutlet var staticSetStrength: UILabel!
    @IBOutlet var staticSetDefence: UILabel!
    @IBOutlet var staticSetMagic: UILabel!
    @IBOutlet var staticSetRange: UILabel!
    @IBOutlet var staticSetPrayer: UILabel!
    @IBOutlet var staticSetSummoning: UILabel!
    @IBOutlet var staticSetConstitution: UILabel!

// Set Levels Labels
    @IBOutlet var attackOut: UILabel!
    @IBOutlet var strengthOut: UILabel!
    @IBOutlet var defenceOut: UILabel!
    @IBOutlet var magicOut: UILabel!
    @IBOutlet var rangeOut: UILabel!
    @IBOutlet var prayerOut: UILabel!
    @IBOutlet var summoningOut: UILabel!
    @IBOutlet var constitutionOut: UILabel!

// Other
    @IBOutlet var button: UIButton!
    @IBOutlet var scroll: UIScrollView!
    @IBOutlet var currentLevel: UILabel!
    @IBOutlet var currentStatic: UILabel!
    @IBOutlet var nextLevel: UILabel!
    @IBOutlet var nextStatic: UILabel!
    @IBOutlet var needStatic: UILabel!
    var calcualted = false
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
    var summoning: Int {
        if summoningIn.text != "" {
            return Int(summoningIn.text!)!
        } else {
            return 1
        }
    }
    var constitution: Int {
        if constitutionIn.text != "" {
            return Int(constitutionIn.text!)!
        } else {
            return 10
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: .UIKeyboardDidHide, object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if UIDevice().model == "iPad" {
            visible()
            calculate(self)
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
        summoningIn.inputAccessoryView = dv
        constitutionIn.inputAccessoryView = dv
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        scroll.addGestureRecognizer(tap)
        
        let bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        bannerView.adUnitID = "ca-app-pub-9515262034988468/4212206831"
        bannerView.rootViewController = self
        
        view.addSubview(bannerView)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: bannerView, attribute: .bottom, relatedBy: .equal, toItem: scroll, attribute: .bottom, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: bannerView, attribute: .centerX, relatedBy: .equal, toItem: scroll, attribute: .centerX, multiplier: 1, constant: 0))
        
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        bannerView.load(request)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardDidHide, object: nil)
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
    
    var atk: Int { return attack + strength }
    var ranger: Int { return range * 2 }
    var mage: Int { return magic * 2 }
    var health: Int { return defence + constitution }
    var pray: Int { return prayer / 2 }
    var summ: Int { return summoning / 2 }
    
    @IBAction func calculate(_ sender: AnyObject) {
        
        if !calcualted {
            calcualted = true
        }
        
        if (attack + strength) > (magic * 2) && (attack + strength) > (range * 2) {
            let sum: Double = 1.3 * Double(atk) + Double(health) + Double(pray) + Double(summ)
            lvl = Int(sum / 4)
            fightTitle = .melee
        } else if (magic * 2) > (strength + attack) && (magic * 2) > (range * 2) {
            let sum: Double = 1.3 * Double(mage) + Double(health) + Double(pray) + Double(summ)
            lvl = Int(sum / 4)
            fightTitle = .mage
        } else if (range * 2) > (strength + attack) && (range * 2) > (magic * 2) {
            let sum: Double = 1.3 * Double(ranger) + Double(health) + Double(pray) + Double(summ)
            lvl = Int(sum / 4)
            fightTitle = .range
        } else {
            if (attack + strength) < (magic * 2) && (attack + strength) < (range * 2) {
                let sum: Double = 1.3 * Double(mage) + Double(health) + Double(pray) + Double(summ)
                lvl = Int(sum / 4)
                fightTitle = .mage
            } else {
                let sum: Double = 1.3 * Double(atk) + Double(health) + Double(pray) + Double(summ)
                lvl = Int(sum / 4)
                fightTitle = .skiller
            }
        }
        
        currentLevel.text = String(lvl)
        if lvl == 138 {
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
                let a = strength + temp
                let sum = 1.3 * Double(a) + Double(health) + Double(pray) + Double(summ)
                i = Int(sum / 4)
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
                let a = temp + attack
                let sum = 1.3 * Double(a) + Double(health) + Double(pray) + Double(summ)
                i = Int(sum / 4)
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
                let a = constitution + temp
                switch fightTitle! {
                case .melee, .skiller:
                    let sum = 1.3 * Double(atk) + Double(a) + Double(pray) + Double(summ)
                    i = Int(sum / 4)
                case .mage:
                    let sum = 1.3 * Double(mage) + Double(a) + Double(pray) + Double(summ)
                    i = Int(sum / 4)
                case .range:
                    let sum = 1.3 * Double(ranger) + Double(a) + Double(pray) + Double(summ)
                    i = Int(sum / 4)
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
                let a = temp * 2
                let sum = 1.3 * Double(a) + Double(health) + Double(pray) + Double(summ)
                i = Int(sum / 4)
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
                let a = temp * 2
                let sum = 1.3 * Double(a) + Double(health) + Double(pray) + Double(summ)
                i = Int(sum / 4)
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
                let a = temp / 2
                switch fightTitle! {
                case .melee, .skiller:
                    let sum = 1.3 * Double(atk) + Double(health) + Double(a) + Double(summ)
                    i = Int(sum / 4)
                case .mage:
                    let sum = 1.3 * Double(mage) + Double(health) + Double(a) + Double(summ)
                    i = Int(sum / 4)
                case .range:
                    let sum = 1.3 * Double(ranger) + Double(health) + Double(a) + Double(summ)
                    i = Int(sum / 4)
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
        
// Summoning
        i = 1
        c = 0
        temp = summoning
        if temp == 99 {
            summoningOut.text = "-"
        } else {
            while i <= lvl {
                temp += 1
                let a = temp / 2
                switch fightTitle! {
                case .melee, .skiller:
                    let sum = 1.3 * Double(atk) + Double(health) + Double(pray) + Double(a)
                    i = Int(sum / 4)
                case .mage:
                    let sum = 1.3 * Double(mage) + Double(health) + Double(pray) + Double(a)
                    i = Int(sum / 4)
                case .range:
                    let sum = 1.3 * Double(ranger) + Double(health) + Double(pray) + Double(a)
                    i = Int(sum / 4)
                }
                c += 1
                if i > lvl {
                    if c > (99 - summoning) {
                        summoningOut.text = "-"
                    } else {
                        summoningOut.text = String(c)
                    }
                }
            }
        }
        
// Constitution
        i = 1
        c = 0
        temp = constitution
        if temp == 99 {
            constitutionOut.text = "-"
        } else {
            while i <= lvl {
                temp += 1
                let a = defence + temp
                switch fightTitle! {
                case .melee, .skiller:
                    let sum = 1.3 * Double(atk) + Double(a) + Double(pray) + Double(summ)
                    i = Int(sum / 4)
                case .mage:
                    let sum = 1.3 * Double(mage) + Double(a) + Double(pray) + Double(summ)
                    i = Int(sum / 4)
                case .range:
                    let sum = 1.3 * Double(ranger) + Double(a) + Double(pray) + Double(summ)
                    i = Int(sum / 4)
                }
                c += 1
                if i > lvl {
                    if c > (99 - constitution) {
                        constitutionOut.text = "-"
                    } else {
                        constitutionOut.text = String(c)
                    }
                }
            }
        }
    }
    
    @IBAction func buttonDidPress(_ sender: UIButton) {
        if !calcualted { calculate(sender) }
        visible()
        staticAttack.isHidden = !staticAttack.isHidden
        staticStrength.isHidden = !staticStrength.isHidden
        staticDefence.isHidden = !staticDefence.isHidden
        staticMagic.isHidden = !staticMagic.isHidden
        staticRange.isHidden = !staticRange.isHidden
        staticPrayer.isHidden = !staticPrayer.isHidden
        staticSummoning.isHidden = !staticSummoning.isHidden
        staticConstitution.isHidden = !staticConstitution.isHidden
        attackIn.isHidden = !attackIn.isHidden
        strengthIn.isHidden = !strengthIn.isHidden
        defenceIn.isHidden = !defenceIn.isHidden
        magicIn.isHidden = !magicIn.isHidden
        rangeIn.isHidden = !rangeIn.isHidden
        prayerIn.isHidden = !prayerIn.isHidden
        summoningIn.isHidden = !summoningIn.isHidden
        constitutionIn.isHidden = !constitutionIn.isHidden
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
        staticSetSummoning.isHidden = !staticSetSummoning.isHidden
        staticSetConstitution.isHidden = !staticSetConstitution.isHidden
        attackOut.isHidden = !attackOut.isHidden
        strengthOut.isHidden = !strengthOut.isHidden
        defenceOut.isHidden = !defenceOut.isHidden
        magicOut.isHidden = !magicOut.isHidden
        rangeOut.isHidden = !rangeOut.isHidden
        prayerOut.isHidden = !prayerOut.isHidden
        summoningOut.isHidden = !summoningOut.isHidden
        constitutionOut.isHidden = !constitutionOut.isHidden
        needStatic.isHidden = !needStatic.isHidden
        currentLevel.isHidden = !currentLevel.isHidden
        currentStatic.isHidden = !currentStatic.isHidden
        nextLevel.isHidden = !nextLevel.isHidden
        nextStatic.isHidden = !nextStatic.isHidden
    }
}
