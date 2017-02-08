//
//  OSViewController.h
//  RS Combat
//
//  Created by Erik Bean on 7/17/14.
//  Copyright (c) 2015 Erik Bean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface OSViewController : UIViewController <ADBannerViewDelegate>

@property NSInteger *attackNumber;
@property NSInteger *strengthNumber;
@property NSInteger *defenceNumber;
@property NSInteger *magicNumber;
@property NSInteger *rangeNumber;
@property NSInteger *prayerNumber;
@property NSInteger *hpNumber;

@end
