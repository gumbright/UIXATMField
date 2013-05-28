//
//  UIXATMField.h
//  UIXATMFieldDemo
//
//  Created by Guy Umbright on 5/23/13.
//  Copyright (c) 2013 Salesforce.com. All rights reserved.
//

typedef enum
{
    UIXATMFieldModeCustom=0,
    UIXATMFieldModeCurrentCurrency,
    UIXATMFieldModePercentage
} UIXATMFieldMode;

#import <UIKit/UIKit.h>

@class UIXATMField;

@protocol UIXATMFieldDelegate <NSObject>

- (void) UIXATMFieldChanged:(UIXATMField*) atmField;

@end 


@interface UIXATMField : UITextField

@property (nonatomic, assign) UIXATMFieldMode mode;
@property (nonatomic, copy) NSDecimalNumber* currentDecimalValue;
@property (nonatomic, assign) float currentValue;

//ignored for currency mode
@property (nonatomic, assign) NSUInteger numDecimalDigits;

//decimal points
//currency mode
//percentage

@end
