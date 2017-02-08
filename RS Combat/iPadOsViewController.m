//
//  iPadOsViewController.m
//  RS Combat
//
//  Created by Erik Bean on 8/12/14.
//  Copyright (c) 2014 Erik Bean. All rights reserved.
//

#import "iPadOsViewController.h"

@interface iPadOsViewController () {
    
    IBOutlet UITextField *attackText;
    IBOutlet UITextField *strengthText;
    IBOutlet UITextField *defenceText;
    IBOutlet UITextField *magicText;
    IBOutlet UITextField *rangeText;
    IBOutlet UITextField *prayerText;
    IBOutlet UITextField *hpText;
    
    IBOutlet UILabel *attackLabel;
    IBOutlet UILabel *strengthLabel;
    IBOutlet UILabel *defenceLabel;
    IBOutlet UILabel *magicLabel;
    IBOutlet UILabel *rangeLabel;
    IBOutlet UILabel *prayerLabel;
    IBOutlet UILabel *hpLabel;
    
    IBOutlet UILabel *attackWord;
    IBOutlet UILabel *strengthWord;
    IBOutlet UILabel *defenceWord;
    IBOutlet UILabel *magicWord;
    IBOutlet UILabel *rangeWord;
    IBOutlet UILabel *prayerWord;
    IBOutlet UILabel *hpWord;
    
    IBOutlet UILabel *maxOne;
    IBOutlet UILabel *maxTwo;
    IBOutlet UILabel *titleWord;
    IBOutlet UILabel *nextWord;
    IBOutlet UILabel *combatLevel;
    IBOutlet UILabel *nextLevel;
    IBOutlet UILabel *combatType;
    IBOutlet UIScrollView *theScroll;
    IBOutlet UIButton *calculate;
    IBOutlet ADBannerView *adBanner;
    
    UITextField *activeField;
    NSInteger attack;
    NSInteger strength;
    NSInteger defence;
    NSInteger magic;
    NSInteger range;
    NSInteger prayer;
    NSInteger hp;
    NSInteger lvl;
    NSString *fightTitle;
    BOOL bannerIsVisable;
}

@end

@implementation iPadOsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    calculate.layer.cornerRadius = 5;
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"768osBackground.png"]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    [theScroll addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    adBanner.delegate = self;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self deregisterFromKeyboardNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    if (!bannerIsVisable) {
        adBanner.hidden = NO;
        bannerIsVisable = YES;
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    if (error) {
        adBanner.hidden = YES;
        bannerIsVisable = NO;
        NSLog(@"AdBanner Error: %ld", (long)[error code]);
        /*
         AdBanner Error: 3 - Ad inventory unavailable
         AdBanner Error: 7 - Ad was unloaded from banner
         */
    }
}

- (void)registerForKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)deregisterFromKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
}

- (void)keyboardWasShown:(NSNotification *)notification {
    if ([attackText isFirstResponder]) {
        activeField = attackText;
    } else if ([strengthText isFirstResponder]) {
        activeField = strengthText;
    } else if ([defenceText isFirstResponder]) {
        activeField = defenceText;
    } else if ([magicText isFirstResponder]) {
        activeField = magicText;
    } else if ([rangeText isFirstResponder]) {
        activeField = rangeText;
    } else if ([prayerText isFirstResponder]) {
        activeField = prayerText;
    } else if ([hpText isFirstResponder]) {
        activeField = hpText;
    }
    
    NSDictionary *info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGPoint buttonOrigin = activeField.frame.origin;
    CGFloat buttonHeight = activeField.frame.size.height;
    CGRect  visibleRect = self.view.frame;
    visibleRect.size.height -= keyboardSize.height;
    
    if (!CGRectContainsPoint(visibleRect, buttonOrigin)) {
        CGPoint scrollPoint = CGPointMake(0, buttonOrigin.y - visibleRect.size.height + buttonHeight);
        [theScroll setContentOffset:scrollPoint animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification *)notificaion {
    [theScroll setContentOffset:CGPointZero animated:YES];
}

- (void)dismissKeyboard {
    [attackText resignFirstResponder];
    [strengthText resignFirstResponder];
    [defenceText resignFirstResponder];
    [magicText resignFirstResponder];
    [rangeText resignFirstResponder];
    [prayerText resignFirstResponder];
    [hpText resignFirstResponder];
}

- (IBAction)work:(id)sender {
    attack = [attackText.text integerValue];
    strength = [strengthText.text integerValue];
    defence = [defenceText.text integerValue];
    magic = [magicText.text integerValue];
    range = [rangeText.text integerValue];
    prayer = [prayerText.text integerValue];
    hp = [hpText.text integerValue];
    
    NSString *empty = @" ";
    NSString *singleMax = @"99";
    
    float sumPrayer = prayer/2;
    float base = (defence + hp + sumPrayer)/4;
    NSInteger warriorNum = attack + strength;
    float warrior = .325 * warriorNum;
    NSInteger rangerNum = 1.5 * range;
    float ranger = .325 * rangerNum;
    NSInteger mageNum = 1.5 * magic;
    float mage = .325 * mageNum;
    
    if ((warrior > ranger) && (warrior > mage)) {
        lvl = base + warrior;
        fightTitle = @"Warrior";
    } else if ((ranger > warrior) && (ranger > mage)) {
        lvl = base + ranger;
        fightTitle = @"Ranger";
    } else if ((mage > warrior) && (mage > ranger)) {
        lvl = base + mage;
        fightTitle = @"Mage";
    } else {
        lvl = base + warrior;
        fightTitle = @"Warrior";
    }
    
    if (attack == 99 && strength == 99 && defence == 99 && magic == 99 && range == 99 && prayer == 99 && hp == 99) {
        
        combatLevel.text = @"138";
        maxOne.text = @"Oh No!";
        maxTwo.text = @"Your Already Max Combat Level!";
        titleWord.text = empty;
        attackWord.text = empty;
        strengthWord.text = empty;
        defenceWord.text = empty;
        magicWord.text = empty;
        rangeWord.text = empty;
        prayerWord.text = empty;
        hpWord.text = empty;
        nextWord.text = empty;
        nextLevel.text = empty;
        attackLabel.text = empty;
        strengthLabel.text = empty;
        defenceLabel.text = empty;
        magicLabel.text = empty;
        rangeLabel.text = empty;
        prayerLabel.text = empty;
        hpLabel.text = empty;
        combatType.text = @"the strongest!";
    } else {
        maxOne.text = @" ";
        maxTwo.text = @" ";
        titleWord.text = @"You need one of the following to up your combat level:";
        nextWord.text = @"Your Next Level is:";
        attackWord.text = @"Attack Levels";
        strengthWord.text = @"Strength Levels";
        defenceWord.text = @"Defence Levels";
        magicWord.text = @"Magic Levels";
        rangeWord.text = @"Range Levels";
        hpWord.text = @"Hitpoint Levels";
        
        NSInteger next = lvl + 1;
        nextLevel.text = [NSString stringWithFormat:@"%ld", (long) next];
        combatLevel.text = [NSString stringWithFormat:@"%ld", (long) lvl];
        
        NSInteger temp = 0;
        NSInteger i = 1;
        NSInteger c = 0;
        // Attack
        if (attack == 99) {
            attackLabel.text = singleMax;
        } else {
            i = 1;
            c = 0;
            temp = attack;
            while (i <= lvl) {
                temp += 1;
                float sumPrayer = prayer/2;
                float baseMath = (defence + hp + sumPrayer)/4;
                NSInteger num = temp + strength;
                float warriorMath = .325 * num;
                i = baseMath + warriorMath;
                c += 1;
                if (i > lvl) {
                    attackLabel.text = [NSString stringWithFormat:@"%ld", (long)c];
                    combatType.text = @"a warrior.";
                }
            }
        }
        // Strength
        if (strength == 99) {
            strengthLabel.text = singleMax;
        } else {
            i = 1;
            c = 0;
            temp = strength;
            while (i <= lvl) {
                temp += 1;
                float sumPrayer = prayer/2;
                float baseMath = (defence + hp + sumPrayer)/4;
                NSInteger num = attack + temp;
                float warriorMath = .325 * num;
                i = baseMath + warriorMath;
                c += 1;
                if (i > lvl) {
                    strengthLabel.text = [NSString stringWithFormat:@"%ld", (long)c];
                    combatType.text = @"a warrior.";
                }
            }
        }
        // Defence
        if (defence == 99) {
            defenceLabel.text = singleMax;
        } else {
            i = 1;
            c = 0;
            temp = defence;
            while (i <= lvl) {
                temp += 1;
                if ([fightTitle isEqualToString:@"Warrior"]) {
                    float sumPrayer = prayer/2;
                    float baseMath = (temp + hp + sumPrayer)/4;
                    NSInteger num = attack + strength;
                    float warriorMath = .325 * num;
                    i = baseMath + warriorMath;
                    c += 1;
                } else if ([fightTitle isEqualToString:@"Mage"]) {
                    float sumPrayer = prayer/2;
                    float baseMath = (temp + hp + sumPrayer)/4;
                    NSInteger num = magic/2;
                    float mageMath = .325 * num;
                    i = baseMath + mageMath;
                    c += 1;
                } else if ([fightTitle isEqualToString:@"Ranger"]) {
                    float sumPrayer = prayer/2;
                    float baseMath = (temp + hp + sumPrayer)/4;
                    NSInteger num = range/2;
                    float rangerMath = .325 * num;
                    i = baseMath + rangerMath;
                    c += 1;
                }
                if (i > lvl) {
                    defenceLabel.text = [NSString stringWithFormat:@"%ld", (long)c];
                }
            }
        }
        // Magic
        if (magic == 99) {
            magicLabel.text = singleMax;
        } else {
            i = 1;
            c = 0;
            temp = magic;
            while (i <= lvl) {
                temp += 1;
                float sumPrayer = prayer/2;
                float baseMath = (defence + hp + sumPrayer)/4;
                NSInteger num = 1.5 * temp;
                float mageMath = .325 * num;
                i = baseMath + mageMath;
                c += 1;
                if (i > lvl) {
                    magicLabel.text = [NSString stringWithFormat:@"%ld", (long)c];
                    combatType.text = @"a mage.";
                }
            }
        }
        // Range
        if (range == 99) {
            rangeLabel.text = singleMax;
        } else {
            i = 1;
            c = 0;
            temp = range;
            while (i <= lvl) {
                temp += 1;
                float sumPrayer = prayer/2;
                float baseMath = (defence + hp + sumPrayer)/4;
                NSInteger num = 1.5 * temp;
                float rangerMath = .325 * num;
                i = baseMath + rangerMath;
                c += 1;
                if (i > lvl) {
                    rangeLabel.text = [NSString stringWithFormat:@"%ld", (long)c];
                    combatType.text = @"a ranger.";
                }
            }
        }
        // Prayer
        if (prayer == 99) {
            prayerLabel.text = singleMax;
        } else {
            i = 1;
            c = 0;
            temp = prayer;
            while (i <= lvl) {
                temp += 1;
                if ([fightTitle isEqualToString:@"Warrior"]) {
                    float sumPrayer = temp/2;
                    float baseMath = (defence + hp + sumPrayer)/4;
                    NSInteger num = attack + strength;
                    float warriorMath = .325 * num;
                    i = baseMath + warriorMath;
                    c += 1;
                } else if ([fightTitle isEqualToString:@"Mage"]) {
                    float sumPrayer = temp/2;
                    float baseMath = (defence + hp + sumPrayer)/4;
                    NSInteger num = 1.5 * magic;
                    float mageMath = .325 * num;
                    i = baseMath + mageMath;
                    c += 1;
                } else if ([fightTitle isEqualToString:@"Ranger"]) {
                    float sumPrayer = temp/2;
                    float baseMath = (defence + hp + sumPrayer)/4;
                    NSInteger num = 1.5 * range;
                    float rangerMath = .325 * num;
                    i = baseMath + rangerMath;
                    c += 1;
                }
                if (i > lvl) {
                    prayerLabel.text = [NSString stringWithFormat:@"%ld", (long)c];
                }
            }
        }
        // Hitpoints
        if (hp == 99) {
            hpLabel.text = singleMax;
        } else {
            i = 1;
            c = 0;
            temp = hp;
            while (i <= lvl) {
                temp += 1;
                if ([fightTitle isEqualToString:@"Warrior"]) {
                    float sumPrayer = prayer/2;
                    float baseMath = (defence + temp + sumPrayer)/4;
                    NSInteger num = attack + strength;
                    float warriorMath = .325 * num;
                    i = baseMath + warriorMath;
                    c += 1;
                } else if ([fightTitle isEqualToString:@"Mage"]) {
                    float sumPrayer = prayer/2;
                    float baseMath = (defence + temp + sumPrayer)/4;
                    NSInteger num = 1.5 * magic;
                    float mageMath = .325 * num;
                    i = baseMath + mageMath;
                    c += 1;
                } else if ([fightTitle isEqualToString:@"Ranger"]) {
                    float sumPrayer = prayer/2;
                    float baseMath = (defence + temp + sumPrayer)/4;
                    NSInteger num = 1.5 * range;
                    float rangerMath = .325 * num;
                    i = baseMath + rangerMath;
                    c += 1;
                }
                if (i > lvl) {
                    hpLabel.text = [NSString stringWithFormat:@"%ld", (long)c];
                }
            }
        }
    }
}

@end
