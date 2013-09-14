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

- (void)setProgram:(id)program {
    _program = program;
    [self.graphView setNeedsDisplay];
    [self setTitle:[CalculatorModel programDesc:program]];
}

- (void)setGraphView:(GraphView *)graphView {
    // set
    _graphView = graphView;
    
    // set delegate
    self.graphView.dataSource = self;
}

- (void)viewDidLoad {
    [self loadUserDefaults];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self saveUserDefaults];
}

- (void)saveUserDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithFloat:self.graphView.origin.x] forKey:@"originX"];
    [defaults setObject:[NSNumber numberWithFloat:self.graphView.origin.y] forKey:@"originY"];
    [defaults setObject:[NSNumber numberWithFloat:self.graphView.scale] forKey:@"scale"];
    [defaults synchronize];
}

- (void)loadUserDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *originX = [defaults objectForKey:@"originX"];
    NSNumber *originY = [defaults objectForKey:@"originY"];
    NSNumber *scale = [defaults objectForKey:@"scale"];
    if (originX && originY && scale) {
        CGPoint origin;
        origin.x = [originX floatValue];
        origin.y = [originY floatValue];
        self.graphView.origin = origin;
        self.graphView.scale = [scale floatValue];
        NSLog(@"user default origin and scale loaded");
    }
}

@end