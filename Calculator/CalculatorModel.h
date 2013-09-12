//
//  CalculatorModel.h
//  Calculator
//
//  Created by Nop Jiarathanakul on 9/10/13.
//  Copyright (c) 2013 Prutsdom Jiarathanakul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorModel : NSObject

- (void)removeLastOperand;
- (void)pushOperand:(double)operand;
- (double)performOperation:(NSString *)operation;
- (void)clearStack;
- (NSString *)printStack;

@property (readonly) id program;

+ (NSString *)programDesc:(id)program;
+ (double)runProgram:(id)program;
+ (double)runProgram:(id)program
            withVars:(NSDictionary *)vars;
+ (double)varsInProgram:(id)program;

@end
