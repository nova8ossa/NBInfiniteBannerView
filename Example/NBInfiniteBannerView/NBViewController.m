//
//  NBViewController.m
//  NBInfiniteBannerView
//
//  Created by 梵天 on 11/23/2015.
//  Copyright (c) 2015 梵天. All rights reserved.
//

#import "NBViewController.h"
#import "NBInfiniteBannerView.h"

@interface NBViewController ()

@property (nonatomic, strong) NBInfiniteBannerView *bannerView;

@end

@implementation NBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _bannerView = [[NBInfiniteBannerView alloc] initWithFrame:CGRectZero];
    _bannerView.backgroundColor = [UIColor yellowColor];
    _bannerView.bannerInsets = UIEdgeInsetsMake(10, 10, 20, 10);
    [self.view addSubview:_bannerView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    _bannerView.frame = CGRectInset(self.view.bounds, 20, 200);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
