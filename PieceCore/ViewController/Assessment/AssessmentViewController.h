
#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "AssessmentPriceRecipient.h"
#import "BuyListData.h"

@interface AssessmentViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (nonatomic) NSString *model_id;
@property (nonatomic) NSString *rank;
@property (nonatomic) int point;
@property (nonatomic) int price;
@property (nonatomic) AssessmentPriceRecipient *priceRecipient;
@property (nonatomic) BuyListData *data;
- (IBAction)assessmentAction:(id)sender;
- (IBAction)hawtowAction:(id)sender;

@end