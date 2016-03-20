//
//  ViewController.m
//  BublesView
//
//  Created by HEYANG on 16/3/20.
//  Copyright © 2016年 HEYANG. All rights reserved.
//

#import "ViewController.h"
#import "BubblesView.h"

@interface ViewController ()

//气泡菜单数据
@property(nonatomic,strong) NSMutableArray *arrayOfBubbles;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
    [btn addTarget:self action:@selector(showBubblesView) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"root_bubble01"] forState:UIControlStateNormal];
    
    btn.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:btn];
}

- (void)showBubblesView{
    CGPoint point =CGPointMake(self.view.center.x, self.view.center.y);
//    __weak UIViewController* vc = self;
    BubblesView* bubblesView = [[BubblesView alloc] initWithPoint:point radius:[UIScreen mainScreen].bounds.size.width/4 inView:self.view];
    if (self.arrayOfBubbles ==nil) {
        self.arrayOfBubbles =[[NSMutableArray alloc]initWithCapacity:3];
        for (int i = 0; i< 3; i++) {
            PNCBubblesItem *item =[[PNCBubblesItem alloc]init];
            item.menuIcon =[NSString stringWithFormat:@"root_bubble0%d.png",i+1];
            [self.arrayOfBubbles addObject:item];
        }
    }
    bubblesView.bubblesItems =_arrayOfBubbles;
    
    [bubblesView setClickBlock:^(NSInteger index){
        if (index ==0) {
            NSLog(@"one");
        }else if (index ==1){
            NSLog(@"two");
        }else if (index ==2){
            NSLog(@"three");
        }
    }];

    
    
    [bubblesView show];
}

@end
