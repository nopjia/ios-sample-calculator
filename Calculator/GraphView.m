//
//  GraphView.m
//  Calculator
//
//  Created by Nop Jiarathanakul on 9/13/13.
//  Copyright (c) 2013 Prutsdom Jiarathanakul. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"
#import "CalculatorModel.h"

@implementation GraphView

// setup method
- (void)setup {
    self.contentMode = UIViewContentModeRedraw;
}
- (void)awakeFromNib {
    [self setup];
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)drawFunction:(id)program
              bounds:(CGRect)screenBounds
              origin:(CGPoint)screenOrigin
               scale:(CGFloat)pointsPerUnit
           inContext:(CGContextRef)context {
    
    double xmin = (screenBounds.origin.x - screenOrigin.x) / pointsPerUnit;
    double xmax = xmin + screenBounds.size.width / pointsPerUnit;
    
    UIGraphicsPushContext(context);
    
    // TODO draw function
    CGContextBeginPath(context);
    
    // iterate across x pixels
    for (int i = 0; i < screenBounds.size.width; ++i) {
        // screen to world coords (i to x)
        double x = (i-screenOrigin.x)/pointsPerUnit;
        
        // eval program
        NSDictionary *vars = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithDouble:x], @"x", nil];
        double y = [CalculatorModel runProgram:program withVars:vars];
        
        // TODO TEST dummy function
        y = sin(x);
        
        // world to screen coords (y to j)
        int j = -y * pointsPerUnit + screenOrigin.y;
        
        // draw
        if (i==0) CGContextMoveToPoint(context, i, j);
        CGContextAddLineToPoint(context, i, j);
    }
    
	CGContextStrokePath(context);
    
    UIGraphicsPopContext();
}

- (void)drawRect:(CGRect)rect {
    
    // get CG context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPoint midPoint;
    midPoint.x = self.bounds.origin.x + self.bounds.size.width / 2;
    midPoint.y = self.bounds.origin.y + self.bounds.size.height / 2;
    
    CGPoint origin = CGPointZero;
    origin = midPoint;
    CGFloat scale = 10.0;
    
    [AxesDrawer drawAxesInRect:self.bounds originAtPoint:origin scale:scale];
    
    // interpret program and graph
    [self drawFunction:[self.dataSource programForGraphView:self]
                bounds:self.bounds
                origin:origin
                 scale:scale
             inContext:context];
}

@end
