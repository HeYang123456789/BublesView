//
//  BubblesView.h


#import "BubblesView.h"
#import "NSObject+Block.h"
@implementation PNCBubblesItem
@synthesize menuId =_menuId;
@synthesize menuIcon =_menuIcon;
@synthesize menuName =_menuName;
@synthesize menuRadius =_menuRadius;

-(id)init{

    if (self ==[super init]) {
        
        self.menuId =@"";
        self.menuIcon =@"";
        self.menuName =@"";
        self.menuRadius =[UIScreen mainScreen].bounds.size.width*0.15;
    }
    return self;
}

@end

@interface BubblesView ()

//是否动画中
@property(nonatomic,readonly) BOOL isAnimating;
//父视图
@property (nonatomic, weak) UIView *parentView;
//背景图
@property(nonatomic,strong) UIImageView *bgImgView;

@property(nonatomic,strong) NSMutableArray *itemViews;

@end

@implementation BubblesView

#pragma mark -init

- (id)initWithPoint:(CGPoint)point radius:(CGFloat)radiusValue inView:(UIView *)inView
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
 
    if (self) {

        self.parentView =inView;
        _isAnimating =NO;
        
        if (self.bgImgView ==nil) {
            
            self.bgImgView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 2 * radiusValue, 2 * radiusValue)];
//            self.bgImgView.image =PNCThemeImageBundle(ThemeFileDir,@"root_bubbleBg.png");
            self.bgImgView.image = [UIImage imageNamed:@"root_bubbleBg"];
            self.bgImgView.userInteractionEnabled =YES;
            self.bgImgView.center =point;
            self.bgImgView.alpha =0;
            
            UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
            [self addGestureRecognizer:singleTap];
            
            [self addSubview:self.bgImgView];
        }
        self.backgroundColor =[UIColor clearColor];
    }
    return self;
}

-(void)setBubblesItems:(NSArray *)bubblesItems{

    _bubblesItems =bubblesItems;
    
    [self loadItemView];
}

-(void)loadItemView{
    
    for (int i = 0 ; i < _bubblesItems.count;  i++) {
      
        PNCBubblesItem *item =self.bubblesItems[i];
        UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame =CGRectMake(0, 0, item.menuRadius, item.menuRadius);
//        [btn setBackgroundImage:PNCThemeImageBundle(ThemeFileDir, item.menuIcon) forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:item.menuIcon] forState:UIControlStateNormal];
        [btn setTag:2015+i];
        [btn addTarget:self action:@selector(menuItemPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        if (self.itemViews ==nil) {
            self.itemViews =[[NSMutableArray alloc]initWithCapacity:_bubblesItems.count];
        }
        [self.itemViews addObject:btn];
    }
}

//根据夹角(与y轴),中心点,半径 就计算出点坐标
- (CGPoint)getMenuCenter:(CGFloat)angle centerOfBubbles:(CGPoint)centerPoint radiusOfBubbles:(CGFloat)radius{

    CGFloat c_x =sinf(angle) * radius + centerPoint.x;
    CGFloat c_y = cosf(angle) * radius + centerPoint.y;
    
    return CGPointMake(c_x, c_y);
}

-(CGFloat)getAngleWith:(NSInteger)index{

    CGFloat angle =0.0f;
    
    angle =(300-(240/(_itemViews.count+1))*(index+1))*M_PI/180;
    
    return angle;
}


#pragma mark -menuItemPressed

-(void)menuItemPressed:(id)sender{

    UIButton *btn =(UIButton *)sender;
    
    [self hide];
    
    float delayTime = self.bubblesItems.count * 0.1 +0.45;

    __block BubblesView *safeSelf =self;
    
    [self perform:^{
        //动画结束，执行回调
        if ([safeSelf clickBlock] && !self.isAnimating) {
            
            [safeSelf clickBlock](btn.tag -2015);
        }
    }andDelay:delayTime];
}

#pragma mark -show/hide View

-(void)show{

    if (self.itemViews.count ==0 || self.isAnimating) {
        return;
    }
    
    _isAnimating =YES;
    [self.parentView addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
    
        self.bgImgView.alpha =1.0f;
    }];
    
    NSMutableArray *coordinates = [NSMutableArray array];
    
    for (int i = 0; i <_itemViews.count; ++i){
        
        UIButton *bubble = [_itemViews objectAtIndex:i];
        
        CGPoint bublesCenter =self.bgImgView.center;
        
        CGFloat radiusOfBubbles =self.bgImgView.frame.size.width/2;
        
        //确定itemView 的中心点
        CGPoint btnCenterPoint =[self getMenuCenter:[self getAngleWith:i] centerOfBubbles:bublesCenter radiusOfBubbles:radiusOfBubbles];
        
        [coordinates addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:btnCenterPoint.x], @"x", [NSNumber numberWithFloat:btnCenterPoint.y], @"y", nil]];
        
        bubble.transform = CGAffineTransformMakeScale(0.001, 0.001);
        bubble.center =self.bgImgView.center;
    }
    
    int interval = 0;
    for (NSDictionary *coordinate in coordinates){
        
        UIButton *bubble = [_itemViews objectAtIndex:interval];
        float delayTime = interval * 0.1;
        [self performSelector:@selector(showBubbleWithAnimation:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:bubble, @"button", coordinate, @"coordinate", nil] afterDelay:delayTime];
        ++interval;
    }
}

-(void)hide{

    if (self.isAnimating) {
        return;
    }
    _isAnimating =YES;
    
    int interval = 0;
    for (UIButton *bubble in _itemViews){
    
        float delayTime = interval * 0.1;
        [self performSelector:@selector(hideBubbleWithAnimation:) withObject:bubble afterDelay:delayTime];
        ++interval;
    }
}

-(void)showBubbleWithAnimation:(NSDictionary *)info{
    
    UIButton *bubble = (UIButton *)[info objectForKey:@"button"];
    NSDictionary *coordinate = (NSDictionary *)[info objectForKey:@"coordinate"];
    
    [UIView animateWithDuration:0.25 animations:^{
        bubble.center = CGPointMake([[coordinate objectForKey:@"x"] floatValue], [[coordinate objectForKey:@"y"] floatValue]);
        bubble.alpha = 1;
        bubble.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            bubble.transform = CGAffineTransformMakeScale(0.8, 0.8);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.15 animations:^{
                bubble.transform = CGAffineTransformMakeScale(1, 1);
            } completion:^(BOOL finished) {
                if(bubble.tag == _itemViews.count +2014){
                    //动画结束
                    _isAnimating = NO;
                }
                bubble.layer.shadowColor = [UIColor blackColor].CGColor;
                bubble.layer.shadowOpacity = 0.2;
                bubble.layer.shadowOffset = CGSizeMake(0, 1);
                bubble.layer.shadowRadius = 2;
            }];
        }];
    }];
}

-(void)hideBubbleWithAnimation:(UIButton *)bubble{
    
    [UIView animateWithDuration:0.2 animations:^{
      
        bubble.transform = CGAffineTransformMakeScale(1.2, 1.2);
        self.bgImgView.alpha =0;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.25 animations:^{
            bubble.center =self.bgImgView.center;
            bubble.transform = CGAffineTransformMakeScale(0.001, 0.001);
            bubble.alpha = 0;
        } completion:^(BOOL finished) {
            if(bubble.tag == _itemViews.count +2014) {
                //动画结束
                _isAnimating = NO;
                
                [self.bgImgView removeFromSuperview];
                [self removeFromSuperview];
            }
            [bubble removeFromSuperview];
        }];
    }];
}

- (void)dealloc{
    NSLog(@"%@退出，销毁了。",self);
}

@end
