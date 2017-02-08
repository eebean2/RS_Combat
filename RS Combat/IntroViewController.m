//
//  IntroViewController.m
//  RS Combats
//
//  Created by Erik Bean on 7/18/14.
//  Copyright (c) 2015 Erik Bean. All rights reserved.
//

#import "IntroViewController.h"

@interface IntroViewController ()

@end

@implementation IntroViewController

- (void)goToNextView {
    [self performSegueWithIdentifier:@"start" sender:self];
}

- (void)viewDidLoad {
    
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    
    if (iOSDeviceScreenSize.height == 480){
        self.backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"640x960.png"]];
        [self.view addSubview:self.backgroundImage];
        [self.view sendSubviewToBack:self.backgroundImage];
    }
    
    if (iOSDeviceScreenSize.height == 568){
        self.backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"640x1136.png"]];
        [self.view addSubview:self.backgroundImage];
        [self.view sendSubviewToBack:self.backgroundImage];
    }
    [self performSelector:@selector(goToNextView) withObject:nil afterDelay:5];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
