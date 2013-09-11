//
//  CalculatorModel.h
//  Calculator
//
//  Created by Nop Jiarathanakul on 9/10/13.
//  Copyright (c) 2013 Prutsdom Jiarathanakul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorModel : NSObject

- (void)pushOperand:(double)operand;
- (double)performUnaryOperation:(NSString *)operation;
- (double)performBinaryOperation:(NSString *)operation;
- (void)clearStack;

@end
