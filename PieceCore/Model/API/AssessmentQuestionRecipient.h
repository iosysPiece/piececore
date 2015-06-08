
#import "BaseRecipient.h"
#import "AssessmentAnswerData.h"

@interface AssessmentQuestionRecipient : BaseRecipient
@property (nonatomic) NSMutableArray *list;
@property (nonatomic) NSString *question_id;
@property (nonatomic) NSString *question_text;
@property (nonatomic) NSString *end_flg;
@end
