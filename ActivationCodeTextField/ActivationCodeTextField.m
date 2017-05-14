//
//  ActivationCodeTextField.m
//
//  Created by Sandeep Aggarwal on 16/03/17.
//  Copyright © 2017 Sandeep Aggarwal. All rights reserved.
//

#import "ActivationCodeTextField.h"

@interface ActivationCodeTextField ()

@property (nonatomic, strong) NSString* space;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) NSString* separator;
@property (nonatomic, strong) NSString* placeholderString;

@property (nonatomic, strong) NSMutableArray<UIAccessibilityElement *>* accessibleElements;

@end

@implementation ActivationCodeTextField

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self)
    {
        return nil;
    }
    
    [self commonInit];

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (!self)
    {
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (void)commonInit
{
    self.space = @" ";
    self.customPlaceholder = @"_" ;
    self.maxCodeLength = 6;
    
    UILabel *label = [UILabel new];
    [label setTextColor:[UIColor blackColor]];
    self.label = label;
    [self addSubview:label];
    
    self.tintColor = [UIColor clearColor]; //to avoid cursor blink
    
    self.keyboardType = UIKeyboardTypeNumberPad;
    
    self.textAlignment = NSTextAlignmentCenter;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textEditingChanged:) name:UITextFieldTextDidChangeNotification object:self];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.label.frame = self.bounds;
    
    _separator = nil;
    [self updateLabel];
}

// so that its subviews can be accessible
- (BOOL)isAccessibilityElement
{
    return NO;
}

#pragma mark - Public Methods

- (CGFloat) minWidthTextField
{
    if (_maxCodeLength == 0)
    {
        return 0.0f;
    }
    
    CGFloat totalMaxWidthCanBeTakenByContent = [self totalMaxWidthCanBeTakenByContent];
   
    NSInteger minNumberOfSpaces = 3;
    NSInteger numGaps = [self numGaps];
    NSInteger numberOfSpacesRequired = minNumberOfSpaces * numGaps;
    CGFloat totalWidthTakenbySpaces  = [self widthOfString:[self spaceString:self.space withNumberOfSpaces:numberOfSpacesRequired]];
    
    return (totalMaxWidthCanBeTakenByContent + totalWidthTakenbySpaces);
}

#pragma mark - Overridden Methods

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    self.label.font = font;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    [super setTextAlignment:textAlignment];
    
    self.label.textAlignment = textAlignment;
}

- (void)setTextColor:(UIColor *)textColor
{
    [super setTextColor:[UIColor clearColor]]; //to avoid showing textfield text
    
    [self.label setTextColor:textColor];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    
    NSInteger textLength = text.length;
    if (textLength == _maxCodeLength)
    {
        if (self.activationCodeTFDelegate && [self.activationCodeTFDelegate respondsToSelector:@selector(fillingCompleteForTextField:)])
        {
            [self.activationCodeTFDelegate fillingCompleteForTextField:self];
        }
    }
}

#pragma mark - overridden accessors

- (NSString*)placeholderString
{
    if (!_placeholderString)
    {
        _placeholderString = [self labelString:self.customPlaceholder];
    }
    
    return _placeholderString;
}

- (NSString*)separator
{
    if (!_separator)
    {
        CGFloat totalMaxWidthCanBeTakenByContent = [self totalMaxWidthCanBeTakenByContent];
        CGFloat widthAllowed = self.label.bounds.size.width;
        CGFloat emptySpaceLeft = widthAllowed - totalMaxWidthCanBeTakenByContent;
        if (emptySpaceLeft > 0)
        {
            NSInteger numGaps = [self numGaps];
            CGFloat separatorWidth = emptySpaceLeft/(numGaps * 1.0f);
            _separator = [self spaceString: self.space withWidth:separatorWidth];
        }
        else
        {
            _separator = @"";
        }
    }
    
    return _separator;
}

- (NSArray *)accessibleElements
{
    if ( _accessibleElements != nil )
    {
        return _accessibleElements;
    }
    _accessibleElements = [[NSMutableArray alloc] init];
    
    UIAccessibilityElement* element = (UIAccessibilityElement*)self.label;
    element.accessibilityIdentifier = @"ACTPlaceholderLabel";
    [_accessibleElements addObject:element];
    
    return _accessibleElements;
}

#pragma mark - Private Methods

- (void)textEditingChanged:(NSNotification *)notification
{
    UITextField* textField = notification.object;
    if (textField != self)
    {
        return;
    }
    
    NSInteger textLength = textField.text.length;
    NSInteger index;
    if (textLength > _maxCodeLength)
    {
        index = _maxCodeLength;
    }
    else
    {
        index = textLength;
    }
    
    textField.text = [textField.text substringToIndex:index];// needed to call so that -setText is called
    [self updateLabel];
}

- (void)updateLabel
{
    NSString* textFieldText = self.text;
    NSInteger textLength = textFieldText.length;
    if (textLength > _maxCodeLength)
    {
        return;
    }
    
    NSMutableString* labelText = [NSMutableString stringWithString:@""];
    NSArray<NSString*>*  numbersArray = [self numbersFromString:textFieldText];
    for (NSString* numberString in numbersArray)
    {
        [labelText appendString:[self labelString:numberString]];
    }
    
    
    for (NSInteger i = textLength; i < _maxCodeLength; i++)
    {
        [labelText appendString:self.placeholderString];
    }
    [self.label setText:labelText];
    self.label.accessibilityValue = labelText; //so that in UITests its text value can be compared
}

- (NSArray<NSString*>*)numbersFromString:(NSString*)string
{
    if (string.length == 0)
    {
        return nil;
    }
    
    NSMutableArray* array = [NSMutableArray new];
    NSInteger stringLength = string.length;
    for (NSInteger i = 0; i < stringLength; i++)
    {
        unsigned int character = [string characterAtIndex:i];
        [array addObject:[NSString stringWithFormat:@"%C",(unichar)character]];
    }
    
    return array;
}

- (CGFloat)totalMaxWidthCanBeTakenByContent
{
    CGFloat maxWidth = [self maxWidthTakenByAnyNumber];
    CGFloat customPlaceholderWidth = [self widthTakenByCustomPlaceholder];
    if (customPlaceholderWidth > maxWidth)
    {
        maxWidth = customPlaceholderWidth;
    }
    CGFloat totalMaxWidthTakenByContent = maxWidth * _maxCodeLength;
    return totalMaxWidthTakenByContent;
}

- (CGFloat)widthTakenByCustomPlaceholder
{
    return [self widthOfString:self.customPlaceholder];
}

- (CGFloat)maxWidthTakenByAnyNumber
{
    CGFloat maxWidth = 0.0f;
    
    CGFloat width;
    NSString* string;
    for (NSInteger i = 0; i < 10; i++)
    {
        string = [NSString stringWithFormat:@"%ld",(long)i];
        width = [self widthOfString:string];
        if (width > maxWidth)
        {
            maxWidth = width;
        }
    }
    
    return maxWidth;
}

- (CGFloat)widthOfString:(NSString*)string
{
    NSDictionary *attr = [NSDictionary dictionaryWithObject:[self font]
                                                     forKey:NSFontAttributeName];
    CGSize stringSize = [string sizeWithAttributes:attr];
    return stringSize.width;
}

- (NSString*)spaceString:(NSString*)spaceString withNumberOfSpaces:(NSInteger)numSpaces
{
    NSMutableString* finalString = [NSMutableString new];
    for (NSInteger i = 0; i < numSpaces; i++)
    {
        [finalString appendString:spaceString];
    }
    
    return finalString;
}

- (NSString*)spaceString:(NSString*)spaceString withWidth:(CGFloat)width
{
    CGFloat spaceStringwidth = [self widthOfString:spaceString];
    NSInteger numberOfSpacesRequired = floorf(width/spaceStringwidth);
    return [self spaceString:spaceString withNumberOfSpaces:numberOfSpacesRequired];
}

- (NSInteger)numGaps
{
    return (_maxCodeLength - 1);
}

- (NSString*)labelString:(NSString*)string
{
    return [NSString stringWithFormat:@"%@%@",string,self.separator];
}

#pragma mark - <UIAccessibilityContainer>

- (NSInteger)accessibilityElementCount
{
    return [[self accessibleElements] count];
}

- (id)accessibilityElementAtIndex:(NSInteger)index
{
    return [[self accessibleElements] objectAtIndex:index];
}

- (NSInteger)indexOfAccessibilityElement:(id)element
{
    return [[self accessibleElements] indexOfObject:element];
}

#pragma mark - dealloc

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
