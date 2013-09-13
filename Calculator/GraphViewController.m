//
//  GraphViewController.m
//  Calculator
//
//  Created by Nop Jiarathanakul on 9/13/13.
//  Copyright (c) 2013 Prutsdom Jiarathanakul. All rights reserved.
//

#import "GraphViewController.h"
#import "GraphView.h"
#import "CalculatorModel.h"

@interface GraphViewController () <GraphViewDataSource>
@property (weak, nonatomic) IBOutlet GraphView *graphView;
@end

@implementation GraphViewController

@synthesize program = _program;
@synthesize graphView = _graphView;

- (id)programForGraphView:(GraphView *)sender {
    return self.program;
}

- (id)program {
    return _program;
}

- (void)setProgram:(id)program {
    _program = program;
    [self.graphView setNeedsDisplay];
    [self setTitle:[CalculatorModel programDesc:program]];
}

- (void)setGraphView:(GraphView *)graphView {
    // set
    _graphView = graphView;
    
    // handle gestures
    [self.graphView addGestureRecognizer:
     [[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinch:)]];
    [self.graphView addGestureRecognizer:
     [[UIPanGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pan:)]];
    [self.graphView addGestureRecognizer:
     [[UITapGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(tap:)]];
    
    // set delegate
    self.graphView.dataSource = self;
}

@end