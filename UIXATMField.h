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
@property (nonatomic, copy) NSDecimalNumber* decimalValue;
@property (nonatomic, assign) float value;

//ignored for currency mode
@property (nonatomic, assign) NSUInteger numDecimalDigits;

//call delegate
//verify values
//cancel/done
//limit perc value

@end
