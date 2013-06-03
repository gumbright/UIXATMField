//
//  UIXATMField.h
//  UIXATMFieldDemo
//
//  Created by Guy Umbright on 5/23/13.
//  Copyright (c) 2013 Salesforce.com. All rights reserved.
//

//going to split the modes out to separate classes at some point

//typedef enum
//{
//    UIXATMFieldModeCustom=0,
//    UIXATMFieldModeCurrentCurrency,
//    UIXATMFieldModePercentage
//} UIXATMFieldMode;

#import <UIKit/UIKit.h>

@class UIXATMField;

@protocol UIXATMFieldDelegate <NSObject>

- (void) UIXATMFieldChanged:(UIXATMField*) atmField;

- (void) UIXATMFieldDonePressed:(UIXATMField*) atmField;
- (void) UIXATMFieldCancelPressed:(UIXATMField*) atmField;

- (BOOL) UIXATMField:(UIXATMField*) atmField shouldChangeValueTo:(NSDecimalNumber*) newValue; 

@end 


@interface UIXATMField : UITextField

//@property (nonatomic, assign) UIXATMFieldMode mode;
@property (nonatomic, copy) NSDecimalNumber* decimalValue;
@property (nonatomic, assign) float value;
@property (nonatomic, weak) NSObject<UIXATMFieldDelegate>* atmFieldDelegate;

//ignored for iPad
@property (nonatomic, assign) BOOL showDone;
@property (nonatomic, assign) BOOL showCancel;

//@property (nonatomic, readonly) NSNumberFormatter* formatter;
@property (nonatomic, strong) NSNumberFormatter* formatter;

//limit perc value

@end

@interface UIXCurrencyATMField : UIXATMField
@end

@interface UIXPercentageATMField : UIXATMField
@end


//!!!in progress/experimental, dont use
@interface UIXUnfixedDecimalATMField : UIXATMField
@end
