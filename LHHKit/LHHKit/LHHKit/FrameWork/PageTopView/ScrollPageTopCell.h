//
//  ScrollPageTopCell.h
//  RenRenCiShanJia
//
//  Created by 李欢欢 on 2017/12/8.
//  Copyright © 2017年 sugarskylove. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollPageModel : NSObject

@property (nonatomic, copy) NSString * title;
@property (nonatomic, assign) BOOL isSelected;
@end

@interface ScrollPageTopCell : UICollectionViewCell

@property (nonatomic, strong) ScrollPageModel * model;

+ (CGSize)returnCellSize;

@end
