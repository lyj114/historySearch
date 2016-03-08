//
//  ViewController.m
//  demo
//
//  Created by 锐拓 on 16/3/7.
//  Copyright © 2016年 锐拓. All rights reserved.
//

#import "ViewController.h"
#import "SearchOneSectionTableViewCell.h"
#import "SearchTwoSectionTableViewHeaderView.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,SearchOneSectionTableViewCellDelegate>
@property (nonatomic, strong)NSMutableArray *historyArr;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)UITextField *textField;
@end

@implementation ViewController
#pragma mark - 懒加载
- (NSMutableArray *)historyArr
{
    if (!_historyArr) {
        NSArray *paths1=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *path1=[paths1 objectAtIndex:0];
        NSString *filename1=[path1 stringByAppendingPathComponent:@"Date.plist"];
        NSMutableArray *array1=[[NSMutableArray alloc] initWithContentsOfFile:filename1];
        array1 = (NSMutableArray *)[[array1 reverseObjectEnumerator] allObjects];
        _historyArr = [NSMutableArray arrayWithArray:array1];
    }
    return _historyArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //    搜索框
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width * 0.65, 35)];
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    imageView.image = [UIImage imageNamed:@"look-grey"];
    imageView.contentMode = UIViewContentModeCenter;
    textField.leftView = imageView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.textColor = [UIColor blackColor];
    UIColor *color = [UIColor blackColor];
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"打底裤" attributes:@{NSForegroundColorAttributeName:color}];
    textField.backgroundColor = [UIColor whiteColor];
    [textField setBorderStyle:UITextBorderStyleRoundedRect];
//    textField.delegate = self;
    [textField becomeFirstResponder];
    textField.delegate = self;
    self.navigationItem.titleView = textField;
    _textField = textField;
    //    rightBarButtonItem
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStyleDone target:self action:@selector(searchProduct)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    //    去掉返回按钮的字
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    //    注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SearchOneSectionTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SearchOneSectionTableViewCell class])];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    //    注册headerView
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SearchTwoSectionTableViewHeaderView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([SearchTwoSectionTableViewHeaderView class])];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //    导航栏颜色
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, 64);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,[UIColor redColor].CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.navigationController.navigationBar setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

#pragma mark 搜索
- (void)searchProduct
{
    if (_textField.text == nil || [_textField.text isEqualToString:@""]) {
//        [MBProgressHUD showError:@"请输入内容"];
    }else{
        [self addStringToPlist:_textField.text];
        [self.tableView reloadData];
//        SearchProductViewController *searchProductVC = [[SearchProductViewController alloc] init];
//        [self.navigationController pushViewController:searchProductVC animated:YES];
    }
}
#pragma mark 往plist中添加字符串
- (void)addStringToPlist:(NSString *)text
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:@"Date.plist"];
    NSMutableArray *array=[[NSMutableArray alloc] initWithContentsOfFile:filename];
    
    if (array == nil) {
        array = [[NSMutableArray alloc] init];
        [array writeToFile:filename atomically:YES];
    }
    NSString *textFieldText = text;
    if (array.count == 0) {
        [array addObject:textFieldText];
    }
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:textFieldText]) {
            *stop = YES;
            return ;
        }
        if (idx == array.count-1) {
            [array addObject:textFieldText];
        }
    }];
    [array writeToFile:filename atomically:YES];

}
#pragma mark 清除历史记录
- (void)clearHistory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths1=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path1=[paths1 objectAtIndex:0];
    NSString *filename1=[path1 stringByAppendingPathComponent:@"Date.plist"];
    
    BOOL ret = [fileManager fileExistsAtPath:filename1];
    if (ret) {
        NSError *err;
        [fileManager removeItemAtPath:filename1 error:&err];
    }
    [_historyArr removeAllObjects];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.historyArr.count == 0) {
        return 1;
    }else{
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return self.historyArr.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        SearchOneSectionTableViewCell *oneSectionCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SearchOneSectionTableViewCell class]) forIndexPath:indexPath];
        oneSectionCell.delegate = self;
        return oneSectionCell;
    }else{
        UITableViewCell *twoSectionCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
        twoSectionCell.textLabel.text = _historyArr[indexPath.row];
        twoSectionCell.selectionStyle = UITableViewCellSelectionStyleNone;

        twoSectionCell.textLabel.font = [UIFont systemFontOfSize:15];
        return twoSectionCell;
    }
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }else{
        SearchTwoSectionTableViewHeaderView *twoSectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([SearchTwoSectionTableViewHeaderView class])];
        return twoSectionHeaderView;
    }
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }else{
        UIView *twoSectionFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
        UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 80, 5, 160, 30)];
        [clearButton setTitle:@"清除历史记录" forState:UIControlStateNormal];
        [clearButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        clearButton.titleLabel.font = [UIFont systemFontOfSize:15];
        clearButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        clearButton.layer.cornerRadius = 5;
        clearButton.clipsToBounds = YES;
        clearButton.layer.borderWidth = 1;
        [clearButton addTarget:self action:@selector(clearHistory) forControlEvents:UIControlEventTouchUpInside];
        [twoSectionFooterView addSubview:clearButton];
        return twoSectionFooterView;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 160;
    }else{
        return 30;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.001;
    }else{
        return 45;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.001;
    }else{
        return 40;
    }
    
}
#pragma mark - SearchOneSectionTableViewCellDelegate
- (void)clickSelectedButtonOnSearchOneSectionTableViewCell:(SearchOneSectionTableViewCell *)cell selectedButton:(UIButton *)button
{
    [self addStringToPlist:button.titleLabel.text];
    [self.tableView reloadData];
//    SearchProductViewController *searchProductVC = [[SearchProductViewController alloc] init];
//    [self.navigationController pushViewController:searchProductVC animated:YES];
}
#pragma mark - textfieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    回收键盘,取消第一响应者
    [textField resignFirstResponder];
    return YES;
}
@end
