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

@interface GraphView()
@property (nonatomic) CGFloat scale;
@property (nonatomic) CGPoint origin;
@end

@implementation GraphView

@synthesize scale = _scale;
@synthesize origin = _origin;

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

#define DEFAULT_SCALE 50.0

- (CGFloat)scale {
    if (!_scale) {
        return DEFAULT_SCALE;
    } else {
        return _scale;
    }
}
- (void)setScale:(CGFloat)scale {
    if (scale != _scale) {
        _scale = scale;
        [self setNeedsDisplay];
    }
}

// defaults to center
- (CGPoint)origin {
    if (!_origin.x || !_origin.y) {
        CGPoint center;
        center.x = self.bounds.origin.x + self.bounds.size.width / 2;
        center.y = self.bounds.origin.y + self.bounds.size.height / 2;
        
        return center;
    } else {
        return _origin;
    }
}
- (void)setOrigin:(CGPoint)origin {
    if (origin.x != _origin.x || origin.y != origin.y) {
        _origin = origin;
        [self setNeedsDisplay];
    }
}

#define LINE_DETAIL 1

- (void)drawFunction:(id)program
              bounds:(CGRect)screenBounds
              origin:(CGPoint)screenOrigin
               scale:(CGFloat)pointsPerUnit
           inContext:(CGContextRef)context {
    
    UIGraphicsPushContext(context);
    
    // TODO draw function
    CGContextBeginPath(context);
    
    [[UIColor redColor] setStroke];
    
    // iterate across x pixels
    for (int i = 0; i < screenBounds.size.width; i+=LINE_DETAIL) {
        // convert screen to world coords (i to x)
        double x = (i-screenOrigin.x)/pointsPerUnit;
        
        // eval program
        NSDictionary *vars = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithDouble:x], @"x", nil];
        double y = [CalculatorModel runProgram:program withVars:vars];
        
        // convert world to screen coords (y to j)
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
        
    [AxesDrawer drawAxesInRect:self.bounds originAtPoint:self.origin scale:self.scale];
    
    // interpret program and graph
    [self drawFunction:[self.dataSource programForGraphView:self]
                bounds:self.bounds
                origin:self.origin
                 scale:self.scale
             inContext:context];
}

- (void)pinch:(UIPinchGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateChanged ||
        gesture.state == UIGestureRecognizerStateEnded) {
        self.scale *= gesture.scale;
        gesture.scale = 1; // reset gesture scale;
    }
}

- (void)pan:(UIPanGestureRecognizer *)gesture {
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        CGPoint trans = [gesture translationInView:self];
        CGPoint newOrigin;
        newOrigin.x = self.origin.x + trans.x;
        newOrigin.y = self.origin.y + trans.y;
        self.origin = newOrigin;
        [gesture setTranslation:CGPointZero inView:self];
        NSLog(@"PAN");
    }
}

- (void)tap:(UITapGestureRecognizer *)gesture {
    
}

@end