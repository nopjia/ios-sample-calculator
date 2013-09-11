//
//  CalculatorModel.m
//  Calculator
//
//  Created by Nop Jiarathanakul on 9/10/13.
//  Copyright (c) 2013 Prutsdom Jiarathanakul. All rights reserved.
//

#import "CalculatorModel.h"

@interface CalculatorModel ()

@property (nonatomic, strong) NSMutableArray *operandStack;

@end

@implementation CalculatorModel

@synthesize operandStack = _operandStack;

- (NSMutableArray *)operandStack {
    if (_operandStack == nil) _operandStack = [[NSMutableArray alloc] init];
    return _operandStack;
}

- (void)clearStack {
    [self.operandStack removeAllObjects];
}

- (void)pushOperand:(double)operand {
    [self.operandStack addObject:[NSNumber numberWithDouble:operand]];
}

- (double)popOperand {
    NSNumber *operand = [self.operandStack lastObject];
    if (operand) [self.operandStack removeLastObject];
    return [operand doubleValue];
}

- (double)performUnaryOperation:(NSString *)operation {
    if ([self.operandStack count] < 1) return 0;
    
    double result = 0;
    
    if ([operation isEqualToString:@"sin"])
        result = sin([self popOperand]);
    else if ([operation isEqualToString:@"cos"])
        result = cos([self popOperand]);
    else if ([operation isEqualToString:@"√"])
        result = sqrt([self popOperand]);
    
    [self pushOperand:result];
    
    return result;
}

- (double)performBinaryOperation:(NSString *)operation {
    // if one or less in stack
    if ([self.operandStack count] <= 1)
        return [[self.operandStack lastObject] doubleValue];
    
    double result = 0;
    
    // perform operation    
    if ([operation isEqualToString:@"+"]) {
        result = [self popOperand] + [self popOperand];
    }
    else if ([operation isEqualToString:@"-"]) {
        double subtractor = [self popOperand];
        result = [self popOperand] - subtractor;
    }
    else if ([operation isEqualToString:@"*"]) {
        result = [self popOperand] * [self popOperand];
    }
    else if ([operation isEqualToString:@"/"]) {
        double divisor = [self popOperand];
        result = [self popOperand] / divisor;
    }
    
    // push result
    [self pushOperand:result];
    
    return result;
}

@end