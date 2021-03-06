//
//  LeftSlideCell.m
//  LeftSlideOptimizedDemo
//
//  Created by 肖扬 on 2017/4/5.
//  Copyright © 2017年 肖扬. All rights reserved.
//

#import "LeftSlideCell.h"

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

@interface LeftSlideCell()

@property(nonatomic,strong)UIView *containerView;
/**标记左滑菜单是否打开*/
@property(nonatomic,assign,readonly)BOOL isOpen;

@end

@implementation LeftSlideCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        for(UIView *sub in self.contentView.subviews) {
            [sub removeFromSuperview];
        }
        [self setUpView];
    }
    return self;
}

- (void)setUpView {
    //取消关注按钮
    UIButton *remarkBtn = [[UIButton alloc]initWithFrame:CGRectMake(kWidth-200, 0, 100, 100)];
    remarkBtn.backgroundColor = [UIColor blueColor];
    [remarkBtn setTitle:@"添加备忘" forState:UIControlStateNormal];
    [remarkBtn setImage:[UIImage imageNamed:@"remark"] forState:UIControlStateNormal];
    remarkBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [remarkBtn addTarget:self action:@selector(remarkAction) forControlEvents:UIControlEventTouchUpInside];
    
    //删除按钮
    UIButton *deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(kWidth-100, 0, 100, 100)];
    [deleteBtn setTitle:@"删除航班" forState:UIControlStateNormal];
    [deleteBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    deleteBtn.backgroundColor = [UIColor redColor];
    [deleteBtn.titleLabel setFont:[UIFont systemFontOfSize:10]];
    [deleteBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:remarkBtn];
    [self.contentView addSubview:deleteBtn];

    //调整button图片和文字位置
    [self setButtonContentCenter:deleteBtn];
    [self setButtonContentCenter:remarkBtn];
    
    //容器视图
    _containerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 100)];
    _containerView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_containerView];
    if(_isOpen)
        _containerView.center = CGPointMake(kWidth/2-200, _containerView.center.y);
    
    //测试Label
    _testLb=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, kWidth - 120, 100)];
    [_containerView addSubview:_testLb];
    
    //添加滑动手势
    UISwipeGestureRecognizer *LeftSwip = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swip:)];
    LeftSwip.direction = UISwipeGestureRecognizerDirectionLeft;
    [_containerView addGestureRecognizer:LeftSwip];
}


- (void)remarkAction {
    if (self.remarkCallBack) {
        self.remarkCallBack();
    }
}

- (void)deleteAction {
    if (self.deleteCallBack) {
        self.deleteCallBack();
    }
}

- (void)swip:(UISwipeGestureRecognizer *)sender {
    //滑动的回调
    if(self.swipCallBack)
        self.swipCallBack();
    //左滑
    if(sender.direction==UISwipeGestureRecognizerDirectionLeft) {
        if(_isOpen)
            return;
        [UIView animateWithDuration:0.3 animations:^{
            sender.view.center=CGPointMake(sender.view.center.x-200, sender.view.center.y);
        }];
        _isOpen=YES;
    }
}

/**关闭左滑菜单*/
- (void)closeMenuWithCompletionHandle:(void (^)(void))completionHandle {
    if(!_isOpen)
        return;
    __weak typeof(self) wkSelf=self;
    [UIView animateWithDuration:0.3 animations:^{
        wkSelf.containerView.center=CGPointMake(kWidth/2, wkSelf.containerView.center.y);
    }completion:^(BOOL finished) {
        if(completionHandle)
            completionHandle();
    }];
    _isOpen=NO;
}


#pragma mark - private

- (void)setButtonContentCenter:(UIButton *)btn {
    
    CGSize imgViewSize,titleSize,btnSize;
    
    UIEdgeInsets imageViewEdge,titleEdge;
    
    CGFloat heightSpace = 10.0f;
    
    
    
    //设置按钮内边距
    
    imgViewSize = btn.imageView.bounds.size;
    
    titleSize = btn.titleLabel.bounds.size;
    
    btnSize = btn.bounds.size;
    
    
    
    imageViewEdge = UIEdgeInsetsMake(40,0.0, btnSize.height -imgViewSize.height - 40, -titleSize.width);
    
    [btn setImageEdgeInsets:imageViewEdge];
    
    titleEdge = UIEdgeInsetsMake(imgViewSize.height +heightSpace, -imgViewSize.width, 0.0, 0.0);
    
    [btn setTitleEdgeInsets:titleEdge];
    
}


@end
