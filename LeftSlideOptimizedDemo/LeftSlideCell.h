//
//  LeftSlideCell.h
//  LeftSlideOptimizedDemo
//
//  Created by 肖扬 on 2017/4/5.
//  Copyright © 2017年 肖扬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftSlideCell : UITableViewCell


/**添加备忘的回调*/
@property(nonatomic,copy)void (^remarkCallBack)();
/**删除的回调*/
@property(nonatomic,copy)void (^deleteCallBack)();
/***滑动的回调*/
@property(nonatomic,copy)void (^swipCallBack)();

@end
