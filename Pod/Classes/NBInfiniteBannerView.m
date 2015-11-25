//
//  NBInfiniteBannerView.m
//  Pods
//
//  Created by NOVA8OSSA on 15/11/23.
//
//

#import "NBInfiniteBannerView.h"
#import "UIImageView+WebCache.h"

@interface NBBannerItemView : UIImageView;

@property (nonatomic, strong) id<NBBannerItemDelegate> item;

@end

@implementation NBBannerItemView

@end

@interface NBInfiniteBannerView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *itemViews;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong, readwrite) UIPageControl *pageControl;

@end

@implementation NBInfiniteBannerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_scrollView];
        
        _itemViews = [NSMutableArray array];
        
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
        _pageControl.hidesForSinglePage = YES;
        [self addSubview:_pageControl];
        
        _bannerInsets = UIEdgeInsetsZero;
        _pageControlOffset = CGPointZero;
        _isTimerEnabled = YES;
    }
    return self;
}

- (void)setItems:(NSArray<NBBannerItemDelegate> *)items {
    _items = items;
    
    [_itemViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_itemViews removeAllObjects];
    
    NSMutableArray *backedItems = [NSMutableArray arrayWithArray:items];
    if (backedItems.count > 1) {
        [backedItems insertObject:[items lastObject] atIndex:0];
        [backedItems addObject:[items firstObject]];
    }
    
    for (id<NBBannerItemDelegate> item in backedItems) {
        NBBannerItemView *itemView = [[NBBannerItemView alloc] initWithFrame:CGRectZero];
        itemView.item = item;
        itemView.userInteractionEnabled = YES;
        [itemView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)]];
        
        NSString *itemURL = nil;
        UIImage *placeholderImage = nil;
        if ([item respondsToSelector:@selector(bannerItemURL)]) {
            itemURL = [item bannerItemURL];
        }
        if ([item respondsToSelector:@selector(placeholderImage)]) {
            placeholderImage = [item placeholderImage];
        }
        [itemView sd_setImageWithURL:[NSURL URLWithString:itemURL] placeholderImage:placeholderImage];
        [_itemViews addObject:itemView];
        [_scrollView addSubview:itemView];
    }
    
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = items.count;
    
    [self setNeedsLayout];
}

- (void)handleTap:(UITapGestureRecognizer *)ges {
    
    if (_callback) {
        NBBannerItemView *itemView = (NBBannerItemView *)ges.view;
        _callback(itemView.item);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize size = self.bounds.size;
    _scrollView.frame = CGRectMake(_bannerInsets.left, _bannerInsets.top,
                                   size.width - _bannerInsets.left -_bannerInsets.right,
                                   size.height -_bannerInsets.top -_bannerInsets.bottom);
    
    CGSize scrollSize = _scrollView.bounds.size;
    if (_pageControl.numberOfPages > 1) {
        _scrollView.contentSize = CGSizeMake(scrollSize.width*_itemViews.count, scrollSize.height);
        _scrollView.contentOffset = CGPointMake(scrollSize.width, 0.f);
    }
    _pageControl.center = CGPointMake(ceilf(self.bounds.size.width*0.5 + _pageControlOffset.x),
                                      ceilf(self.bounds.size.height - _bannerInsets.bottom*0.5 + _pageControlOffset.y));

    for (NSInteger i = 0; i < _itemViews.count; i++) {
        UIImageView *imageView = _itemViews[i];
        imageView.frame = CGRectMake(scrollSize.width*i, 0, scrollSize.width, scrollSize.height);
    }
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    
    [self fireTimer:!!newWindow];
}

- (void)fireTimer:(BOOL)on {
    
    [_timer invalidate];
    if (_pageControl.numberOfPages > 1 && _isTimerEnabled && on) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:(_timerInterval > 0. ? _timerInterval : 3.f)
                                                  target:self
                                                selector:@selector(timerFireMethod:)
                                                userInfo:nil
                                                 repeats:YES];
    }
}

- (void)timerFireMethod:(NSTimer *)timer {
    
    NSLog(@"banner timer fired...");
    
    if (_scrollView.tracking || !self.window) {
        return;
    }
    
    NSInteger index = 1;
    if (_pageControl.currentPage == _pageControl.numberOfPages - 1) {
        _scrollView.contentOffset = CGPointMake(1, 0);
    }else{
        index = _pageControl.currentPage + 2;
    }
    
    if (index < _itemViews.count) {
        UIImageView *imageView = _itemViews[index];
        [_scrollView scrollRectToVisible:imageView.frame animated:YES];
    }
}

- (void)setBannerInsets:(UIEdgeInsets)bannerInsets {
    
    _bannerInsets = bannerInsets;
    [self setNeedsLayout];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat gap = scrollView.bounds.size.width;
    float loc = scrollView.contentOffset.x / gap - 0.5;
    
    if (loc < 0) {
        _pageControl.currentPage = _pageControl.numberOfPages - 1;
    }else if (loc >= _pageControl.numberOfPages) {
        _pageControl.currentPage = 0;
    }else{
        NSInteger index = loc;
        if (_pageControl.currentPage != index) {
            _pageControl.currentPage = index;
        }
    }
    
    if (scrollView.contentOffset.x <= 0) {
        scrollView.contentOffset = CGPointMake(gap*_items.count, 0);
    }else if (scrollView.contentOffset.x >= (_itemViews.count - 1)*gap) {
        scrollView.contentOffset = CGPointMake(gap, 0);
    }
}

- (void)dealloc {
    
    [_timer invalidate];
    _scrollView.delegate = nil;
}

@end
