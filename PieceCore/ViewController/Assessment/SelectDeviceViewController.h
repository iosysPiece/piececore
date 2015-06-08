
#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "AssessmentModelRecipient.h"
#import "BuyListData.h"

@interface SelectDeviceViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (nonatomic) int selectDevice;
@property (nonatomic) int selectCarria;
@property (nonatomic) NSString *modelName;
@property (nonatomic) AssessmentModelRecipient *assessmentRecipient;
@property (nonatomic) NSMutableArray *buyDatas;

@end
