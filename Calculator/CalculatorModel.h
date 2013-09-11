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
- (double)performOperation:(NSString *)operation;
- (void)clearStack;
- (NSString *)printStack;

@property (readonly) id program;

+ (double)runProgram:(id)program;
+ (NSString *)programDesc:(id)program;

@end
