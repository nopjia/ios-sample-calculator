//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Prutsdom Jiarathanakul on 9/10/13.
//  Copyright (c) 2013 Prutsdom Jiarathanakul. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorModel.h"

@interface CalculatorViewController ()

@property (nonatomic) BOOL userEnteringNumber;
@property (nonatomic, strong) CalculatorModel *calcModel;

@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize commands = _commands;
@synthesize userEnteringNumber = _userEnteringNumber;
@synthesize calcModel = _calcModel;

- (CalculatorModel *)calcModel {
    if (!_calcModel) {
        _calcModel = [[CalculatorModel alloc] init];
    }
    return _calcModel;
}

- (void)recordCommand:(NSString *)str {
    self.commands.text = [NSString stringWithFormat:@"%@ %@", self.commands.text, str];
}

- (IBAction)clearPressed:(UIButton *)sender {
    self.display.text = @" ";
    self.commands.text = @" ";
    [self.calcModel clearStack];
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = sender.currentTitle;
    
    // check illegal decimal
    if ([digit isEqualToString:@"."]) {
        if ([self.display.text rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"."]].location != NSNotFound)
        return;
    }
    
    if (self.userEnteringNumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
        self.userEnteringNumber = YES;
    }
}

- (IBAction)symbolPressed:(UIButton *)sender {
    if (self.userEnteringNumber) {
        [self enterPressed];
    }
    self.display.text = sender.currentTitle;
    self.userEnteringNumber = YES;
    [self enterPressed];
}

- (IBAction)unaryOperationPressed:(UIButton *)sender {
    if (self.userEnteringNumber) {
        [self enterPressed];
    }
    double result = [self.calcModel performUnaryOperation:sender.currentTitle];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    [self recordCommand:sender.currentTitle];
}

- (IBAction)binaryOperationPressed:(UIButton *)sender {
    if (self.userEnteringNumber) {
        [self enterPressed];
    }
    double result = [self.calcModel performBinaryOperation:sender.currentTitle];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    [self recordCommand:sender.currentTitle];
}

- (IBAction)enterPressed {
    // if not entering number
    if (!self.userEnteringNumber) {
        return;
    }
    
    double number = [self.display.text doubleValue];
    
    // handle special symbols
    if ([self.display.text isEqualToString:@"π"]) {
        number = M_PI;
    } else if ([self.display.text isEqualToString:@"e"]) {
        number = M_E;
    }
    
    // push to stack
    [self.calcModel pushOperand:number];
    self.userEnteringNumber = NO;
    
    // record number
    [self recordCommand:self.display.text];
}

@end
