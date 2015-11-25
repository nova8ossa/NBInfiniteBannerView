//
//  NBBannerModel.h
//  NBInfiniteBannerView
//
//  Created by NOVA8OSSA on 15/11/25.
//  Copyright © 2015年 梵天. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NBInfiniteBannerView.h"

@interface NBBannerModel : NSObject <NBBannerItemDelegate>

@property (nonatomic, copy) NSString *bannerItemURL;

@end
