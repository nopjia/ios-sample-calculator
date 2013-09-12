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

- (void)removeLastOperand {
    if ([self.programStack lastObject]) {
        [self.programStack removeLastObject];
    }
}

- (void)pushOperand:(double)operand {
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (double)performOperation:(NSString *)operation {
    [self.programStack addObject:operation];
    return [CalculatorModel runProgram:self.program];
}

+ (BOOL)isBinaryOperation: (NSString *)str {
    NSSet *binary = [NSSet setWithObjects:@"+", @"-", @"*", @"/", nil];
    return [binary containsObject:str];
}
+ (BOOL)isUnaryOperation: (NSString *)str {
    NSSet *unary = [NSSet setWithObjects:@"sin", @"cos", @"tan", @"log", @"sqrt", @"√", nil];
    return [unary containsObject:str];
}

+ (NSString *)programDescHelper:stack {
    NSString *result = @"";
    
    // pop top of stack
    id topOfStack = [stack lastObject];
    if (topOfStack) {
        [stack removeLastObject];
    }
    
    // if number, return that number
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [NSString stringWithFormat:@"%@",topOfStack];
    }
    
    // if string, can be operator or variable
    else if ([topOfStack isKindOfClass:[NSString class]]) {
        // binary operators
        if ([self isBinaryOperation:topOfStack]) {
            NSString *op1 = [self programDescHelper:stack];
            NSString *op2 = [self programDescHelper:stack];
            result = [NSString stringWithFormat:@"(%@ %@ %@)",
                      op2, topOfStack, op1];
        }
        
        // unary operators
        else if ([self isUnaryOperation:topOfStack]) {
            result = [NSString stringWithFormat:@"%@(%@)",
                      topOfStack,
                      [self programDescHelper:stack]];
        }
        
        // variable or symbol
        else {
            result = topOfStack;
        }
    }

    
    return result;
}

+ (NSString *)programDesc:(id)program {
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    
    NSString *result = [self programDescHelper:stack];
    
    while ([stack lastObject]) {
        result = [NSString stringWithFormat:@"%@, %@", [self programDescHelper:stack], result];
    }
    
    return result;
}

+ (double)popOperand:(NSMutableArray *)stack
            withVars:(NSDictionary *)vars
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
    // if string, can be operator or variable
    else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;
        
        // binary operators
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperand:stack withVars:vars] +
                    [self popOperand:stack withVars:vars];
        }
        else if ([operation isEqualToString:@"*"]) {
            result = [self popOperand:stack withVars:vars] *
                    [self popOperand:stack withVars:vars];
        }
        else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperand:stack withVars:vars];
            result = [self popOperand:stack withVars:vars] - subtrahend;
        }
        else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperand:stack withVars:vars];
            if (divisor) result = [self popOperand:stack withVars:vars] / divisor;
        }
        
        // unary operators
        else if ([operation isEqualToString:@"sin"]) {
            result = sin( [self popOperand:stack withVars:vars] );
        }
        else if ([operation isEqualToString:@"cos"]) {
            result = cos( [self popOperand:stack withVars:vars] );
        }
        else if ([operation isEqualToString:@"√"]) {
            result = sqrt( [self popOperand:stack withVars:vars] );
        }
        
        // symbols
        else if ([operation isEqualToString:@"π"]) {
            result = M_PI;
        }
        else if ([operation isEqualToString:@"e"]) {
            result = M_E;
        }
        
        // variable
        else {
            result = [[vars valueForKey:operation] doubleValue];
        }
    }
    
    return result;
}

+ (double)runProgram:(id)program
{
    return [self runProgram:program withVars:nil];
}

+ (double)runProgram:(id)program
            withVars:(NSDictionary *)vars {
    NSMutableArray *stack;
    
    // check for Array type, make mutable copy
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    
    // return result. if not Array type, zero.
    return [self popOperand:stack withVars:vars];
}

+ (double)varsInProgram:(id)program {
    // TODO
    return 0;
}

@end