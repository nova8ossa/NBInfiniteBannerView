//
//  NBInfiniteBannerView.h
//  Pods
//
//  Created by NOVA8OSSA on 15/11/23.
//
//

#import <UIKit/UIKit.h>

@protocol NBBannerItemDelegate <NSObject>

@optional

- (NSString *)bannerItemURL;

- (UIImage *)placeholderImage;

@end

@interface NBInfiniteBannerView : UIView

@property (nonatomic, assign) UIEdgeInsets bannerInsets;
@property (nonatomic, assign) CGPoint pageControlOffset;
@property (nonatomic, strong, readonly) UIPageControl *pageControl;
@property (nonatomic, assign) BOOL isTimerEnabled;
@property (nonatomic, assign) CGFloat timerInterval;
@property (nonatomic, strong) NSArray<NBBannerItemDelegate> *items;
@property (nonatomic, copy) void (^callback) (id<NBBannerItemDelegate> item);

@end
