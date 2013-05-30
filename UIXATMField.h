//
//  UIXATMField.h
//  UIXATMFieldDemo
//
//  Created by Guy Umbright on 5/23/13.
//  Copyright (c) 2013 Salesforce.com. All rights reserved.
//

//going to split the modes out to separate classes at some point

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
@property (nonatomic, weak) NSObject<UIXATMFieldDelegate>* atmFieldDelegate;
//@property (nonatomic, readonly) NSNumberFormatter* formatter;
@property (nonatomic, strong) NSNumberFormatter* formatter;

- (void) setCustomFormatter:(NSNumberFormatter*) formatter;
//verify values
//cancel/done
//limit perc value

@end
