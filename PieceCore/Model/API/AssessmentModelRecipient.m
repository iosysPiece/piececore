
#import "AssessmentModelRecipient.h"


@implementation AssessmentModelRecipient
-(void)setData{
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

-(AssessmentModelData *)setChildData:(NSDictionary *)dec{
    AssessmentModelData *data = [[AssessmentModelData alloc]init];
    data.model_id = [dec valueForKey:@"model_id"];
    data.model_name = [dec valueForKey:@"model_name"];
    data.carrier_type = [dec valueForKey:@"carrier_type"];
    data.device_type = [dec valueForKey:@"device_type"];
    return data;
}
@end
