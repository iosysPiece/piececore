

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "AssessmentModelData.h"
#import "AssessmentQuestionRecipient.h"
#import "AssessmentViewController.h"
#import "BuyListData.h"

@interface QuestionViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UIView *questionVew;
@property (weak, nonatomic) IBOutlet UILabel *questionLbl;
@property (weak, nonatomic) IBOutlet UITableView *table;
//@property (nonatomic) AssessmentModelData *modelData;
@property (nonatomic) int questionCount;
@property (nonatomic) int point;
@property (nonatomic) int price;
@property (nonatomic) AssessmentQuestionRecipient *questionRecipient;
@property (nonatomic) BuyListData *data;
@end
