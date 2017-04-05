//
//  ViewController.m
//  LeftSlideOptimizedDemo
//
//  Created by 肖扬 on 2017/4/5.
//  Copyright © 2017年 肖扬. All rights reserved.
//

#import "ViewController.h"
#import "LeftSlideCell.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView  *tableView;
@property (nonatomic, strong) NSMutableArray *timeArr;
@property (nonatomic, strong) NSMutableDictionary *flightsDic;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    [self initData];
    // Do any additional setup after loading the view, typically from a nib.
}


#pragma mark - Init
- (void)initViews {
    [self.view addSubview:self.tableView];
}

- (void)initData {
    NSMutableArray *marr1 = [NSMutableArray arrayWithObjects:@"flight 1", @"flight 2", nil];
    NSMutableArray *marr2 = [NSMutableArray arrayWithObjects:@"flight 3", @"flight 4", nil];
    NSDictionary *dic = @{@"2017-04-03": marr1,
                          @"2017-04-04": marr2};
    NSArray *arr = dic.allKeys;
    
    [self.timeArr addObjectsFromArray:arr];
    [self.flightsDic addEntriesFromDictionary:dic];
    
}


#pragma mark - Getter
- (UITableView *)tableView {
    CGFloat widht = [[UIScreen mainScreen] bounds].size.width;
    CGFloat height = [[UIScreen mainScreen] bounds].size.height;
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, widht, height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)timeArr {
    if (!_timeArr) {
        _timeArr = [NSMutableArray array];
    }
    return _timeArr;
}

- (NSMutableDictionary *)flightsDic {
    if (!_flightsDic) {
        _flightsDic = [NSMutableDictionary dictionary];
    }
    return _flightsDic;
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.timeArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *key = self.timeArr[section];
    NSArray *arr = self.flightsDic[key];
    
    return arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *key = self.timeArr[indexPath.section];
    NSArray *arr = self.flightsDic[key];
    
    static NSString *cellId = @"cellId";
    LeftSlideCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[LeftSlideCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.testLb.text = arr[indexPath.row];
    
    __weak typeof(self) weakSelf = self;
    __weak typeof(cell) weakCell = cell;
    cell.remarkCallBack = ^{
        __strong typeof(weakCell)strongCell = weakCell;
        [strongCell closeMenuWithCompletionHandle:^{
            NSLog(@"添加备忘！！！");
        }];
    };
    
    cell.deleteCallBack = ^{
        __strong typeof(weakCell)strongCell = weakCell;
        __strong typeof(weakSelf)strongSelf = weakSelf;
        
        [strongCell closeMenuWithCompletionHandle:^{
            NSString *key = strongSelf.timeArr[indexPath.section];
            NSMutableArray *marr = strongSelf.flightsDic[key];
            
            
            [marr removeObjectAtIndex:indexPath.row];
            if (marr.count == 0) {
                [strongSelf.timeArr removeObject:key];
            }
            
            // 接着刷新view
            [strongSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            NSLog(@"删除航班");

        }];
    };
    
    
    cell.swipCallBack = ^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf disappearMenuWithTableView:tableView];
    };
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self disappearMenuWithTableView:tableView];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.timeArr[section];
}

//收起左滑菜单
- (void)disappearMenuWithTableView:(UITableView *)tableView {
    for(LeftSlideCell *tmpCell in tableView.visibleCells)
        [tmpCell closeMenuWithCompletionHandle:nil];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
