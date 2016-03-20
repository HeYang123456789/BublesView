//
//  BubblesView.h


#import <UIKit/UIKit.h>
/**
 *  气泡样式菜单数据项
 */
@interface PNCBubblesItem : NSObject

@property(nonatomic,copy) NSString *menuId;

@property(nonatomic,copy) NSString *menuIcon;

@property(nonatomic,copy) NSString *menuName;

@property(nonatomic,assign) CGFloat menuRadius;

@end

/**
 *  气泡样式菜单
 */
@interface BubblesView : UIView
/**
 *  数据项
 */
@property(nonatomic,strong) NSArray *bubblesItems;
/**
 *  回调方法
 */
@property(nonatomic,copy) void (^clickBlock)(NSInteger index);

/**
 *  初始化方法
 *
 *  @param point       动画中心点位置
 *  @param radiusValue 半径
 *  @param inView      父视图
 *
 *  @return 实例化
 */
- (id)initWithPoint:(CGPoint)point radius:(CGFloat)radiusValue inView:(UIView *)inView;
/**
 *  显示
 */
-(void)show;
/**
 *  隐藏
 */
-(void)hide;

@end
