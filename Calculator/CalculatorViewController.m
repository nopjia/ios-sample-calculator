//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Nop Jiarathanakul on 9/10/13.
//  Copyright (c) 2013 Nop Jiarathanakul. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorModel.h"

@interface CalculatorViewController ()

@property (nonatomic) BOOL userEnteringNumber;
@property (nonatomic, strong) CalculatorModel *calcModel;

@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize cmdView = _cmdView;
@synthesize stackView = _stackView;
@synthesize userEnteringNumber = _userEnteringNumber;
@synthesize calcModel = _calcModel;

- (CalculatorModel *)calcModel {
    if (!_calcModel) {
        _calcModel = [[CalculatorModel alloc] init];
    }
    return _calcModel;
}

- (void)updateStackView {
    self.stackView.text = self.calcModel.printStack;
}

- (void)updateCmdView {
    self.cmdView.text = [CalculatorModel programDesc:self.calcModel.program];
}

- (IBAction)clearPressed:(UIButton *)sender {
    self.display.text = @" ";
    self.cmdView.text = @" ";
    self.stackView.text = @" ";
    [self.calcModel clearStack];
}

- (IBAction)undoPressed:(UIButton *)sender {
    [self.calcModel removeLastOperand];
    
    self.display.text = [NSString stringWithFormat:@"%g",[CalculatorModel runProgram:self.calcModel.program]];
    
    [self updateCmdView];
    [self updateStackView];
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = sender.currentTitle;
    
    // Check illegal decimal
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

- (IBAction)operationPressed:(UIButton *)sender {
    if (self.userEnteringNumber) {
        [self enterPressed];
    }
    double result = [self.calcModel performOperation:sender.currentTitle];
    self.display.text = [NSString stringWithFormat:@"%g", result];

    [self updateCmdView];
    [self updateStackView];
}

- (IBAction)enterPressed {
    
    // If not entering number
    if (!self.userEnteringNumber) {
        return;
    }
    
    double number = [self.display.text doubleValue];
    
    // Handle special symbols
    if ([self.display.text isEqualToString:@"π"]) {
        number = M_PI;
    } else if ([self.display.text isEqualToString:@"e"]) {
        number = M_E;
    }
    
    // Push to stack
    [self.calcModel pushOperand:number];
    self.userEnteringNumber = NO;
    
    [self updateCmdView];
    [self updateStackView];
}

@end
