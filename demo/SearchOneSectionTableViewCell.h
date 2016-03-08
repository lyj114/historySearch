//
//  SearchOneSectionTableViewCell.h
//  xiuyue
//
//  Created by 锐拓 on 16/3/5.
//  Copyright © 2016年 锐拓. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearchOneSectionTableViewCell;
@protocol SearchOneSectionTableViewCellDelegate <NSObject>

@optional
- (void)clickSelectedButtonOnSearchOneSectionTableViewCell:(SearchOneSectionTableViewCell *)cell selectedButton:(UIButton *)button;
@end
@interface SearchOneSectionTableViewCell : UITableViewCell
@property (nonatomic, weak)id<SearchOneSectionTableViewCellDelegate>delegate;
@end
