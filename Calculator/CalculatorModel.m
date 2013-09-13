//
//  CalculatorModel.m
//  Calculator
//
//  Created by Nop Jiarathanakul on 9/10/13.
//  Copyright (c) 2013 Nop Jiarathanakul. All rights reserved.
//

#import "CalculatorModel.h"

@interface CalculatorModel ()

@property (nonatomic, strong) NSMutableArray *programStack;

@end

@implementation CalculatorModel

@synthesize programStack;

- (id)program {
    // returns an immutable array copy
    return [self.programStack copy];
}

- (NSMutableArray *)programStack {
    if (!programStack) {
        programStack = [[NSMutableArray alloc] init];
    }
    return programStack;
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

+ (BOOL)isBinaryOperation:(NSString *)str {
    NSSet *binary = [NSSet setWithObjects:@"+", @"-", @"*", @"/", nil];
    return [binary containsObject:str];
}
+ (BOOL)isUnaryOperation:(NSString *)str {
    NSSet *unary = [NSSet setWithObjects:@"sin", @"cos", @"tan", @"sqrt", @"√", @"ln", @"log", nil];
    return [unary containsObject:str];
}

+ (NSString *)programDescHelper:(NSMutableArray *)stack {
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
            // look ahead 2 steps (for parens)
            NSString *opNext1, *opNext2;
            if (stack.count > 2) {
                opNext1 = [NSString stringWithFormat:@"%@",stack[stack.count-1]];
                opNext2 = [NSString stringWithFormat:@"%@",stack[stack.count-2]];
            }
            
            // recursive ops
            NSString *op1 = [self programDescHelper:stack];
            NSString *op2 = [self programDescHelper:stack];
            
            if ([topOfStack isEqualToString:@"*"] ||
                [topOfStack isEqualToString:@"/"]) {
                
                // put parens around +/-
                if ([opNext1 isEqualToString:@"+"] ||
                    [opNext1 isEqualToString:@"-"]) {
                    op1 = [NSString stringWithFormat:@"(%@)",op1];
                }
                if ([opNext2 isEqualToString:@"+"] ||
                    [opNext2 isEqualToString:@"-"]) {
                    op2 = [NSString stringWithFormat:@"(%@)",op2];
                }
                
                result = [NSString stringWithFormat:@"%@ %@ %@",
                          op2, topOfStack, op1];
            }
            else {
                result = [NSString stringWithFormat:@"%@ %@ %@",
                          op2, topOfStack, op1];
            }
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
            withVars:(NSDictionary *)vars {
    double result = 0;
    
    // pop top of stack
    id topOfStack = [stack lastObject];
    if (!topOfStack) {
        return result;
    }
    [stack removeLastObject];
    
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
        } else if ([operation isEqualToString:@"*"]) {
            result = [self popOperand:stack withVars:vars] *
                     [self popOperand:stack withVars:vars];
        } else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperand:stack withVars:vars];
            result = [self popOperand:stack withVars:vars] - subtrahend;
        } else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperand:stack withVars:vars];
            if (divisor) result = [self popOperand:stack withVars:vars] / divisor;
            
        } else
        
        // unary operators
        if ([operation isEqualToString:@"sin"]) {
            result = sin([self popOperand:stack withVars:vars]);
        } else if ([operation isEqualToString:@"cos"]) {
            result = cos([self popOperand:stack withVars:vars]);
        } else if ([operation isEqualToString:@"tan"]) {
            result = tan([self popOperand:stack withVars:vars]);
        } else if ([operation isEqualToString:@"√"]) {
            result = sqrt([self popOperand:stack withVars:vars]);
        } else if ([operation isEqualToString:@"ln"]) {
            result = log([self popOperand:stack withVars:vars]);
        } else
        
        // symbols
        if ([operation isEqualToString:@"π"]) {
            result = M_PI;
        } else if ([operation isEqualToString:@"e"]) {
            result = M_E;
        }
        
        // variable
        else {
            result = [[vars valueForKey:operation] doubleValue];
        }
    }
    
    return result;
}

+ (double)runProgram:(id)program {
    return [self runProgram:program withVars:nil];
}

+ (double)runProgram:(id)program
            withVars:(NSDictionary *)vars {
    NSMutableArray *stack = nil;
    
    // check for Array type, make mutable copy
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    
    // return result. if not Array type, zero.
    return [self popOperand:stack withVars:vars];
}

@end