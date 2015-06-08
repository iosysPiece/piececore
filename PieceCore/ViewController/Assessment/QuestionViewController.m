
#import "QuestionViewController.h"

@interface QuestionViewController ()

@end

@implementation QuestionViewController

-(void)viewDidLoadLogic{
    self.questionVew.backgroundColor = [UIColor whiteColor];
    self.questionVew.layer.cornerRadius = 20;
    self.questionVew.layer.borderColor = [UIColor blackColor].CGColor;
    self.questionVew.layer.borderWidth = 1;
    
    self.shadowView.backgroundColor = [UIColor clearColor];
    self.shadowView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.shadowView.layer.shadowOffset = CGSizeMake(1, 1);
    self.shadowView.layer.shadowOpacity = 5.7f;
    self.shadowView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.shadowView.bounds].CGPath;
    self.price = -1;
}

- (void)viewDidAppearLogic{
    self.questionCount = 1;
    self.point = 100;
    [self syncAction];
    
}
-(void)syncAction{
    
    NetworkConecter *conecter = [NetworkConecter alloc];
    conecter.delegate = self;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param setValue:[NSString stringWithFormat:@"%d",self.questionCount] forKey:@"question_id"];
    [conecter sendActionSendId:@"assessment/index.php?Action=getQuestion" param:param];
    
}

-(void)setDataWithRecipient:(AssessmentQuestionRecipient *)recipient sendId:(NSString *)sendId{
    self.questionRecipient = recipient;
    
    self.questionLbl.text = self.questionRecipient.question_text;
    [self.table reloadData];
}

-(BaseRecipient *)getDataWithSendId:(NSString *)sendId{
    return [AssessmentQuestionRecipient alloc];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"CreateCell%ld",(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    AssessmentAnswerData *data = [self.questionRecipient.list objectAtIndex:indexPath.row];
    
    
    UILabel *textLbl = [[UILabel alloc] initWithFrame:CGRectMake(30,15,self.viewSize.width - 80,40)];
    textLbl.text = data.answer_text;
    textLbl.font = [UIFont fontWithName:@"AppleGothic" size:15];
    textLbl.alpha = 1.0f;
    textLbl.backgroundColor = [UIColor clearColor];
    textLbl.numberOfLines = 4;
    [cell.contentView addSubview:textLbl];
    
    //}
    return cell;
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 60.0f;
    } else {
        return 60.0f;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.questionRecipient.list.count;
    } else {
        return 0;
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AssessmentAnswerData *data = [self.questionRecipient.list objectAtIndex:indexPath.row];
    int minus_point = data.minus_point.intValue;
    self.point += minus_point;
    
    if (self.price < 0) {
        if ([@"S" isEqualToString:data.rank]) {
            self.price = self.data.price.intValue;
            
        } else {
            self.price = self.data.used_price.intValue;
        }
        if (self.price == 0) {
            AssessmentViewController *vc = [[AssessmentViewController alloc] initWithNibName:@"AssessmentViewController" bundle:nil];
            vc.model_id = self.data.model;
            vc.title = @"ASSESSMENT";
            vc.data = self.data;
            vc.point = self.point;
            vc.price = self.price;
            [self.navigationController pushViewController:vc animated:YES];
        }
        DLog(@"査定スタート価格：%d",self.price);
    }
    
    
    self.price *= data.Coefficient.doubleValue;
    //下一桁を0にする
    NSMutableString *price = [NSMutableString stringWithFormat:@"%d",self.price];
    [price replaceCharactersInRange:NSMakeRange(price.length-1, 1) withString:@"0"];
    
    DLog(@"係数1：%@ 係数：%f 査定価格：%d",data.Coefficient ,data.Coefficient.doubleValue, self.price);
    self.price = price.intValue;
    DLog(@"端数処理価格：%d",self.price);
    
    if ([self.questionRecipient.end_flg isEqualToString:@"1"] ||
        [data.end_flg isEqualToString:@"1"]) {
        
        AssessmentViewController *vc = [[AssessmentViewController alloc] initWithNibName:@"AssessmentViewController" bundle:nil];
        vc.model_id = self.data.model;
        vc.title = @"ASSESSMENT";
        vc.data = self.data;
        vc.point = self.point;
        vc.price = self.price;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        self.questionCount ++;
        [self syncAction];
    }
}


@end
