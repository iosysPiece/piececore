

#import "AssessmentQuestionRecipient.h"

@implementation AssessmentQuestionRecipient

-(void)setData{
    self.question_id =[self.resultset valueForKey:@"question_id"];
    self.question_text =[self.resultset valueForKey:@"question_text"];
    self.end_flg =[self.resultset valueForKey:@"end_flg"];
    //リスト
    self.list = [[NSMutableArray alloc]init];
    NSMutableArray *dataList = [self.resultset objectForKey:@"list"];
    if ([dataList isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dec in dataList) {
            [self.list addObject:[self setChildData:dec]];
        }
    } else if (dataList != nil) {
        [self.list addObject:[self setChildData:(NSDictionary *)dataList]];
    }
}

-(AssessmentAnswerData *)setChildData:(NSDictionary *)dec{
    AssessmentAnswerData *data = [[AssessmentAnswerData alloc]init];
    data.answer_id = [dec valueForKey:@"answer_id"];
    data.answer_text = [dec valueForKey:@"answer_text"];
    data.minus_point = [dec valueForKey:@"minus_point"];
    data.Coefficient = [dec valueForKey:@"coefficient"];
    data.rank = [dec valueForKey:@"rank"];
    data.end_flg = [dec valueForKey:@"end_flg"];
    return data;
}
@end
