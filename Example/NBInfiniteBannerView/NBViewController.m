//
//  NBViewController.m
//  NBInfiniteBannerView
//
//  Created by 梵天 on 11/23/2015.
//  Copyright (c) 2015 梵天. All rights reserved.
//

#import "NBViewController.h"
#import "NBInfiniteBannerView.h"
#import "NBBannerModel.h"

@interface NBViewController ()

@property (nonatomic, strong) NBInfiniteBannerView *bannerView;

@end

@implementation NBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.title = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleNameKey];
    _bannerView = [[NBInfiniteBannerView alloc] initWithFrame:CGRectZero];
    _bannerView.backgroundColor = [UIColor yellowColor];
    _bannerView.bannerInsets = UIEdgeInsetsMake(10, 10, 20, 10);
    _bannerView.pageControl.pageIndicatorTintColor = [UIColor blueColor];
    _bannerView.pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
    
    NSMutableArray *items = [NSMutableArray array];
    NBBannerModel *item = [[NBBannerModel alloc] init];
    item.bannerItemURL = @"http://images.freeimages.com/images/previews/dc8/a-bowl-of-salad-1318427.jpg";
    [items addObject:item];
    
    item = [[NBBannerModel alloc] init];
    item.bannerItemURL = @"http://images.freeimages.com/images/previews/2a9/passion-fruit-1057366.jpg";
    [items addObject:item];
    
    item = [[NBBannerModel alloc] init];
    item.bannerItemURL = @"http://images.freeimages.com/images/previews/c32/asparagus-isolated-on-white-photos-1057359.jpg";
    [items addObject:item];
    
    _bannerView.items = (NSArray<NBBannerItemDelegate> *)items;
    [self.view addSubview:_bannerView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    _bannerView.frame = CGRectInset(self.view.bounds, 20, 100);
}
- (IBAction)TestTimer:(id)sender {
    
    UIViewController *vc = [UIViewController new];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.title = @"should not be looped";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
