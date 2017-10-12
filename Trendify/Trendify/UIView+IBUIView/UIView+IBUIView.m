//
//  UIView+IBUIView.m
//  IPO
//
//  Created by Chandan on 01/03/2016.
//  Copyright © 2016 Pratham Software Inc. All rights reserved.
//

#import "UIView+IBUIView.h"

@implementation UIView (IBUIView)
@dynamic borderColor,borderWidth,cornerRadius,masksToBounds,shadowWidth;
-(void)setBorderColor:(UIColor *)borderColor{
    [self.layer setBorderColor:borderColor.CGColor];
}

-(void)setBorderWidth:(NSInteger)borderWidth{
    [self.layer setBorderWidth:borderWidth];
}

-(void)setCornerRadius:(NSInteger)cornerRadius{
	[self.layer setCornerRadius:cornerRadius];
}
-(void)setMasksToBounds:(BOOL)masksToBounds{
    [self.layer setMasksToBounds:masksToBounds];
}

-(void)setShadowWidth:(NSInteger)shadowWidth{
    self.layer.shadowColor = [[UIColor grayColor] CGColor];
    self.layer.shadowOpacity = 0.5f;
    self.layer.shadowOffset = CGSizeMake(shadowWidth, shadowWidth);
}

@end


