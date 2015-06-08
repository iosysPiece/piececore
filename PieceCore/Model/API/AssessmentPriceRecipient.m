
#import "AssessmentPriceRecipient.h"

@implementation AssessmentPriceRecipient
-(void)setData{
    self.price =[self.resultset valueForKey:@"price"];
}

@end
