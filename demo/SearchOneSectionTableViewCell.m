//
//  SearchOneSectionTableViewCell.m
//  xiuyue
//
//  Created by 锐拓 on 16/3/5.
//  Copyright © 2016年 锐拓. All rights reserved.
//

#import "SearchOneSectionTableViewCell.h"
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

@interface SearchOneSectionTableViewCell ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong)NSMutableArray *productArr;
@end
@implementation SearchOneSectionTableViewCell
- (NSMutableArray *)productArr
{
    if (!_productArr) {
        NSArray *array = @[@"酷【裤】有型",@"热搜群英汇",@"丝袜",@"单鞋",@"面膜",@"台灯",@"充电宝",@"玻璃杯",@"帽子",@"自行车",@"亲子装",@"汽车用品", @"男装", @"女装"];
        _productArr = [NSMutableArray arrayWithArray:array];
    }
    return _productArr;
}

- (void)awakeFromNib {
    //    滑动选择
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(MainScreenWidth * 2, 30);
    _scrollView.delegate = self;
//    第一页
    UIView *page1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 96)];
    [self.scrollView addSubview:page1];
    NSMutableArray *page1Arr = [NSMutableArray array];
    for (int i = 0; i < 12; i++) {
        [page1Arr addObject:self.productArr[i]];
    }
    for (int i = 0; i < page1Arr.count; i++) {
        CGFloat width = MainScreenWidth/4;
        CGFloat line = i%4;
        CGFloat row = i/4;
        CGFloat height = 32;
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(line*width, row*height, width, height)];
        [button setTitle:page1Arr[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button addTarget:self action:@selector(selectedBtn:) forControlEvents:UIControlEventTouchUpInside];
        [page1 addSubview:button];
    }
//    第二页
    UIView *page2 = [[UIView alloc] initWithFrame:CGRectMake(MainScreenWidth, 0, MainScreenWidth, 96)];
    [self.scrollView addSubview:page2];
    NSMutableArray *page2Arr = [NSMutableArray array];
    for (int i = 0; i < self.productArr.count-12; i++) {
        [page2Arr addObject:self.productArr[i+12]];
    }
    for (int i = 0; i < page2Arr.count; i++) {
        CGFloat width = MainScreenWidth/4;
        CGFloat line = i%4;
        CGFloat row = i/4;
        CGFloat height = 32;
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(line*width, row*height, width, height)];
        [button setTitle:page2Arr[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button addTarget:self action:@selector(selectedBtn:) forControlEvents:UIControlEventTouchUpInside];
        [page2 addSubview:button];
    }
}

#pragma mark 下边的选项被点击，直接跳转下个页面
- (void)selectedBtn:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(clickSelectedButtonOnSearchOneSectionTableViewCell: selectedButton:)]) {
        [self.delegate clickSelectedButtonOnSearchOneSectionTableViewCell:self selectedButton:button];
    }
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int itemIndex = (scrollView.contentOffset.x + scrollView.frame.size.width * 0.5) / scrollView.frame.size.width;
    int index = itemIndex % 4;
    _pageControl.currentPage = index;
}

@end
