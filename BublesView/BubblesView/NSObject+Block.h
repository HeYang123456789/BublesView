//
//  NSObject+DDObject.h


#import <Foundation/Foundation.h>

@interface NSObject (Block)

-(void)perform:(void (^)(void))performBlock;

-(void)perform:(void (^)(void))performBlock andDelay:(NSTimeInterval)delay;

@end
