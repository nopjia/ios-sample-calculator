//
//  CalculatorModel.m
//  Calculator
//
//  Created by Nop Jiarathanakul on 9/10/13.
//  Copyright (c) 2013 Prutsdom Jiarathanakul. All rights reserved.
//

#import "CalculatorModel.h"

@interface CalculatorModel ()

@property (nonatomic, strong) NSMutableArray *programStack;

@end

@implementation CalculatorModel

@synthesize programStack = _programStack;

- (id)program {
    // returns an immutable array copy
    return [self.programStack copy];
}

- (NSMutableArray *)programStack {
    if (_programStack == nil) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}

- (void)clearStack {
    [self.programStack removeAllObjects];
}

- (NSString *)printStack {
    return [NSString stringWithFormat:@"%@", self.programStack];
}

- (void)pushOperand:(double)operand {
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (double)performOperation:(NSString *)operation {
    [self.programStack addObject:operation];
    return [CalculatorModel runProgram:self.program];
}

+ (NSString *)programDesc:(id)program {
    return @"TODO";
}

+ (double)popOperand:(NSMutableArray *)stack
{
    double result = 0;
    
    // pop top of stack
    id topOfStack = [stack lastObject];
    if (topOfStack) {
        [stack removeLastObject];
        NSLog(@"popped %@", topOfStack);
    }    
    
    // introspection
    
    // if number, return that number
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [topOfStack doubleValue];
    }
    // if operator, perform operation
    else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperand:stack] +
                    [self popOperand:stack];
        } else if ([operation isEqualToString:@"*"]) {
            result = [self popOperand:stack] *
                    [self popOperand:stack];
        } else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperand:stack];
            result = [self popOperand:stack] - subtrahend;
        } else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperand:stack];
            if (divisor) result = [self popOperand:stack] / divisor;
        } else if ([operation isEqualToString:@"sin"]) {
            result = sin( [self popOperand:stack] );
        } else if ([operation isEqualToString:@"cos"]) {
            result = cos( [self popOperand:stack] );
        } else if ([operation isEqualToString:@"√"]) {
            result = sqrt( [self popOperand:stack] );
        }
    }
    
    return result;
}

+ (double)runProgram:(id)program
{
    NSMutableArray *stack;
    
    // check for Array type, make mutable copy
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    
    // return result. if not Array type, zero.
    return [self popOperand:stack];
}

@end