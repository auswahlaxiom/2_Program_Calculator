//
//  CalculatorBrain.h
//  1_Calculator
//
//  Created by Zachary Fleischman on 1/14/13.
//  Copyright (c) 2013 Zachary Fleischman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand: (double)operand;
- (void)pushVariable: (NSString *)variable;
- (double)performOperation: (NSString *)operation;
- (void)clear;

@property (readonly) id program;
@property (strong, nonatomic) NSDictionary *variableValues;
@property (nonatomic, strong) NSDictionary *test1;
@property (nonatomic, strong) NSDictionary *test2;

+ (double)runProgram: (id)program;
+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;

+ (NSString *)descriptionOfProgram: (id)program;

+ (NSSet *)variablesUsedInProgram:(id)program;


@end
