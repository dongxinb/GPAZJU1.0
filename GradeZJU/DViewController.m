
//
//  DViewController.m
//  GradeZJU
//
//  Created by 董鑫宝 on 13-8-18.
//  Copyright (c) 2013年 董鑫宝. All rights reserved.
//
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
#define GB2312_ENCODING CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)

#import "DViewController.h"
#import "DLoginViewController.h"
#import "DAboutViewController.h"
#import "DLeftViewController.h"
#import "PKRevealController.h"
#import "Dgrade.h"
#import "ASIFormDataRequest.h"
#import "SIAlertView.h"
#import "DCell.h"
#import "DRow.h"
#import <AVOSCloud/AVOSCloud.h>
@interface DViewController (){
    NSMutableArray *objects;
    NSInteger nowExpand;
    UIRefreshControl *rc;
}

@end

@implementation DViewController
int tempcount;
int successcount;
//BOOL firstLogin;
//- (id)initWithStyle:(UITableViewStyle)style
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    //self = [super initWithStyle:style];
    if (iPhone5) {
        self = [super initWithNibName:@"DViewController" bundle:nibBundleOrNil];
    }else{
        self = [super initWithNibName:@"DViewController35" bundle:nibBundleOrNil];
    }
    if (self) {
        // Custom initialization
    }
    firstLogin=NO;
    return self;
}
+ (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [AVAnalytics beginLogPageView:@"GradePage1.0"];
}

-(void)viewWillDisappear:(BOOL)animated
{
//    NSIndexPath *Index0=[NSIndexPath indexPathForRow:0 inSection:0];
//    DRow *temp=[objects objectAtIndex:0];
//    if (temp.isExpanded==NO) {
//        [self tableView:self.tableView didSelectRowAtIndexPath:Index0];
//    }
    [super viewWillDisappear:animated];
    [AVAnalytics endLogPageView:@"GradePage1.0"];
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES]; 
}
- (void)viewDidLoad
{
    [super viewDidLoad];
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"mode"];
    
    nowExpand=-1;
    //[self.revealController showViewController:self.revealController.frontViewController];
    didLogin=[[NSUserDefaults standardUserDefaults]boolForKey:@"login"];
    self.tableView.scrollsToTop=YES;
    
    if (didLogin==YES) {
       // [DViewController setExtraCellLineHidden:self.tableView];
        rc = [[UIRefreshControl alloc] init];
        rc.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
        [rc addTarget:self action:@selector(refreshTableView)
     forControlEvents:UIControlEventValueChanged];
        self.refreshControl = rc;
        
        [self loadAll];
    }else{
        [self loadAll];
        //self.tableView.hidden=TRUE;
        [DViewController setExtraCellLineHidden:self.tableView];
        
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"deviceToken"] length]!=0) {
            AVQuery *query=[AVQuery queryWithClassName:@"studentPush"];
            [query whereKey:@"deviceToken" equalTo:[[NSUserDefaults standardUserDefaults]objectForKey:@"deviceToken"]];
            [query findObjectsInBackgroundWithBlock:^(NSArray *myobjects, NSError *error) {
                if (!error) {
                    for (AVObject *object in myobjects){
                        //[object deleteInBackground];
                        [object deleteEventually];
                    }
                } else {
                    return;
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
    }
    

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //objects=[[NSMutableArray alloc]initWithObjects:@"2012-2013",@"2011-2012",@"2010-2011", nil];
    

}

-(void) loadAll{
    
//    DCell *celltemp=[[DCell alloc]init];
//    NSIndexPath *tempIndex=[NSIndexPath indexPathForRow:0 inSection:0];
//    celltemp=(DCell *)[self.tableView cellForRowAtIndexPath:tempIndex];
//    NSLog(@"%@",celltemp.kecheng.text);
//    if ([celltemp.kecheng.text isEqualToString:@"无数据"]) {
//        [self.tableView deleteRowsAtIndexPaths:@[tempIndex] withRowAnimation:UITableViewRowAnimationFade];
//        [self.tableView insertRowsAtIndexPaths:@[tempIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
//    }
    
    NSDate * senddate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH:mm"];
    NSCalendar * cal=[NSCalendar currentCalendar];
    NSUInteger unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:senddate];
    NSInteger year=[conponent year];
    
    
    NSMutableArray *tempArray=[[NSMutableArray alloc]init];
    DRow *a;
    int tempint=-1;
    int tempint2=-1;
    a=[objects objectAtIndex:0];
    if (a.superId==-3) {
        [objects removeObjectAtIndex:0];
    }
    NSDictionary *dic;
    for (int i=0; i<=year-2006; i++) {
        dic=[[NSDictionary alloc]init];
        dic=[[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%d-%d-1",year-i,year-i+1]];
        //NSLog(@"%@",dic);
        if ([dic count]!=0) {
            tempint=i;
            if (tempint!=-1 && tempint2==-1) {
                tempint2=i;
            }
            a=[[DRow alloc]init];
            a.kechengtemp=[NSString stringWithFormat:@"%d-%d",year-i,year-i+1];
            a.superId=-1;
            a.isExpanded=NO;
            a.selfId=i+1;
            a.year=year-i;
            [tempArray addObject:a];
        }
        
    }
    if (tempint2==-1) {
        a=[[DRow alloc]init];
        a.kechengtemp=@"无数据";
        a.superId=-3;
        a.isExpanded=NO;
        a.selfId=0;
        a.year=0;
        [tempArray addObject:a];
    }
//    }else{
//        a=[[DRow alloc]init];
//        a.kechengtemp=[NSString stringWithFormat:@"%d-%d",year-tempint2,year-tempint2+1];
//        a.superId=-1;
//        a.isExpanded=NO;
//        a.selfId=tempint2+1;
//        a.year=year-tempint2;
//        [tempArray insertObject:a atIndex:0];
//        [tempArray removeObjectAtIndex:1];
//    }
    objects=[[NSMutableArray alloc]initWithArray: tempArray];

        
    
//    if ([objects count]!=0) {
//        NSIndexPath *Index0=[NSIndexPath indexPathForRow:0 inSection:0];
//        [self tableView:self.tableView didSelectRowAtIndexPath:Index0];
//        nowExpand=0;
//    }
    
    [self.tableView reloadData];
    
}

-(void) refreshTableView
{
    if (self.refreshControl.refreshing) {                                       
        self.refreshControl.attributedTitle = [[NSAttributedString
                                                alloc]initWithString:@"加载中..."];                                 
        //查询请求数据
        [self login];
        //[self performSelector:@selector(login) withObject:nil];
                                                          
    }
}

-(void)reloadView
{
    if (nowExpand!=-1) {
        NSIndexPath *indexTemp=[NSIndexPath indexPathForRow:nowExpand inSection:0];
        [self tableView:self.tableView didSelectRowAtIndexPath:indexTemp];
        nowExpand=-1;
    }
    //[self loadAll];
    
    //[self performSelector:@selector(loadAll)];
    //[self performSelectorOnMainThread:@selector(loadAll) withObject:nil waitUntilDone:YES];
    [self.refreshControl endRefreshing];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
    //[self loadAll];
    [self performSelector:@selector(loadAll) withObject:nil afterDelay:0.5];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [objects count];
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    DRow *temp=[[DRow alloc]init];
    temp = [objects objectAtIndex:indexPath.row];
    if (temp.superId==-1||temp.superId==-3) {
        cell.backgroundColor=[UIColor colorWithRed:3./255. green:173./255. blue:255./255. alpha:1.0];
    }else if (temp.selfId==-2) {
        cell.backgroundColor=[UIColor colorWithRed:231/255. green:231/255. blue:231/255. alpha:1];
    }else{
        cell.backgroundColor=[UIColor whiteColor];
        //cell.backgroundColor=[UIColor colorWithRed:231/255. green:231/255. blue:231/255. alpha:1];
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
    
    static NSString *CellIdentifier = @"GradeCell";
    DCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
//        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"Dcell" owner:self options:nil];
//        cell = [array objectAtIndex:0];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Dcell"
                                                     owner:self options:nil];
        
        for (id oneObject in nib) {
            if ([oneObject isKindOfClass:[DCell class]]) {
                cell = (DCell *)oneObject;
                break;
            }
        }
    }
    DRow *temp=[[DRow alloc]init];
    //NSLog(@"haha%@",objects);
    temp = [objects objectAtIndex:indexPath.row];
    //temp = objects[indexPath.row];
    
    if (temp.superId==-1) {
        int year=temp.year;
        [cell.parentYear setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:22]];
        [cell.parentXN setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
        cell.parentYear.text=[NSString stringWithFormat:@"%d-%d",year,year+1];
        [cell.xuefen setTextColor:[UIColor whiteColor]];
        [cell.grade setTextColor:[UIColor whiteColor]];
        [cell.grade setFont:[UIFont fontWithName:@"Helvetica" size:15]];
        [cell.xuefen setFont:[UIFont fontWithName:@"Helvetica" size:12]];
        [cell.kecheng setFont:[UIFont fontWithName:@"System" size:14]];
        //NSLog(@"%@",cell.parentYear.font);
        cell.parentXN.text=@"学年";
        cell.kecheng.text=@"";
        cell.xuefen.text=@"×学分";
        cell.grade.text=@"绩点";
        cell.xueqi.text=@"";
        cell.isNewLabel.text=@"";
    }else if(temp.selfId==-2){
        [cell.grade setTextColor:[UIColor blackColor]];
        [cell.xuefen setTextColor:[UIColor colorWithRed:3./255. green:173./255. blue:255./255. alpha:1.0]];
        [cell.grade setTextColor:[UIColor darkGrayColor]];
        [cell.grade setFont:[UIFont fontWithName:@"Helvetica" size:17]];
        [cell.xuefen setFont:[UIFont fontWithName:@"Helvetica" size:12]];
        [cell.kecheng setFont:[UIFont fontWithName:@"Helvetica" size:12]];
        cell.parentXN.text=@"";
        cell.parentYear.text=@"";
        cell.kecheng.text=@"   (平均)";
        cell.xuefen.text=temp.xuefentemp;
        cell.grade.text=temp.jidiantemp;
        //cell.xueqi.text=temp.xueqitemp;
        cell.xueqi.text=temp.xueqitemp;
        cell.isNewLabel.text=@"";
    }else if(temp.superId==-3){
        [cell.parentYear setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:22]];
        [cell.kecheng setFont:[UIFont fontWithName:@"System" size:14]];
        [cell.grade setTextColor:[UIColor whiteColor]];
        cell.parentYear.text=@"           还没有数据呢……";
        cell.isNewLabel.text=@"";
        
    }else{
        [cell.xuefen setTextColor:[UIColor colorWithRed:3./255. green:173./255. blue:255./255. alpha:1.0]];
        [cell.grade setTextColor:[UIColor darkGrayColor]];
        [cell.grade setFont:[UIFont fontWithName:@"Kannada Sangam MN" size:16]];
        [cell.xuefen setFont:[UIFont fontWithName:@"Helvetica" size:11]];
        [cell.kecheng setFont:[UIFont fontWithName:@"System" size:14]];
        cell.parentXN.text=@"";
        cell.parentYear.text=@"";
        cell.kecheng.text=temp.kechengtemp;
        cell.grade.text=temp.jidiantemp;
        cell.xuefen.text=temp.xuefentemp;
        cell.kecheng.adjustsFontSizeToFitWidth=YES;
        cell.xueqi.text=@"";
        if (temp.isNew==YES) {
            cell.isNewLabel.text=@"New";
        }else{
            cell.isNewLabel.text=@"";
        }
        //cell.kecheng.adjustsLetterSpacingToFitWidth=YES;
    }
    [DViewController setExtraCellLineHidden:tableView];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DRow *temp=[[DRow alloc]init];
    temp = [objects objectAtIndex:indexPath.row];
    if (temp.superId==-1) {
        return 50;
    }else if(temp.superId==-3){
        return 65;
    }
    return 35;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

//- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
//    DCell *a =[objects objectAtIndex:indexPath.row];
//    return a.level;
//}

//- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    DRow *temp = [[DRow alloc]init];
//    DRow *tempsave = [[DRow alloc]init];
//    tempsave=[objects objectAtIndex:indexPath.row];
//    if ((nowExpand!=-1)&&(indexPath.row!=nowExpand)) {
//        temp = [objects objectAtIndex:nowExpand];
//        DRow *_temp;
//        NSIndexPath *deleteIndexPath;
//        int i=0;
//        while(i< [objects count]) {
//            //遍历 总数据的数组
//            _temp =[objects objectAtIndex:i];
//            //判断当前的父Cell selfId 是否等于当前遍历的superId
//            if (_temp.superId == temp.selfId) {
//                //从总数组删除当前父Cell的子Cell的数据
//                [objects removeObjectAtIndex:i];
//                //找到要删除的子Cell 的位置
//                deleteIndexPath=[[NSIndexPath alloc]init];
//                deleteIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
//                //删除子Cell
//                [tableView deleteRowsAtIndexPaths:@[deleteIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//                //因为在循环里remove了一个字节点,所以i--是必要的.
//                i--;
//                //将当前父Cell 的状态修改为 扩展关
//                temp.isExpanded = NO;
//                nowExpand=-1;
//            }
//            i++;
//        }
//    
//        for (i=0;i<[objects count];i++){
//            temp=[objects objectAtIndex:i];
//            if (temp.selfId==tempsave.selfId) {
//                NSIndexPath *indexsave=[NSIndexPath indexPathForItem:i inSection:0];
//                return indexsave;
//            }
//        }
//    }
//    return indexPath;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //得到当前选择行的数据
//    NSIndexPath *tempIndex=[NSIndexPath indexPathForRow:0 inSection:0];
//    [tableView reloadRowsAtIndexPaths:@[tempIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    DRow *temp = [[DRow alloc]init];
    temp = [objects objectAtIndex:indexPath.row];
    //查看当前选择的行是不是可以扩展开的父cell
    if (temp.superId!=-1)
        return;
    //查看当前选择的行是扩展已经开的
    if (temp.isExpanded==YES) {
        //-->当前扩展开,执行扩展关
        
        //遍历 总数据的数组,找到当前选择的父Cell的子Cell,
        //从总数据数组中删除,再从UItableView 中删除
        DRow *_temp;
        NSIndexPath *deleteIndexPath;
        for (int i =indexPath.row+1; i< [objects count]; i++) {
            //遍历 总数据的数组
            _temp =[objects objectAtIndex:i];
            //判断当前的父Cell selfId 是否等于当前遍历的superId
            if (_temp.superId == temp.selfId) {
                //从总数组删除当前父Cell的子Cell的数据
                [objects removeObjectAtIndex:i];
                //找到要删除的子Cell 的位置
                deleteIndexPath=[[NSIndexPath alloc]init];
                deleteIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
                //删除子Cell
                [tableView deleteRowsAtIndexPaths:@[deleteIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                //因为在循环里remove了一个字节点,所以i--是必要的.
                i--;
                //将当前父Cell 的状态修改为 扩展关
                temp.isExpanded = NO;
                nowExpand=-1;
            }else{
                break;
            }
        }
        return;
    }else{
        if (nowExpand!=-1) {
            DRow *tempsave = [[DRow alloc]init];
            tempsave=[objects objectAtIndex:indexPath.row];
                temp = [objects objectAtIndex:nowExpand];
                DRow *_temp;
                NSIndexPath *deleteIndexPath;
                int i=nowExpand+1;
                while(i< [objects count]) {
                    //遍历 总数据的数组
                    _temp =[objects objectAtIndex:i];
                    //判断当前的父Cell selfId 是否等于当前遍历的superId
                    if (_temp.superId == temp.selfId) {
                        //从总数组删除当前父Cell的子Cell的数据
                        [objects removeObjectAtIndex:i];
                        //找到要删除的子Cell 的位置
                        deleteIndexPath=[[NSIndexPath alloc]init];
                        deleteIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
                        //删除子Cell
                        [tableView deleteRowsAtIndexPaths:@[deleteIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                        //因为在循环里remove了一个字节点,所以i--是必要的.
                        i--;
                        //将当前父Cell 的状态修改为 扩展关
                        temp.isExpanded = NO;
                        nowExpand=-1;
                    }else{
                        break;
                    }
                    i++;
                }
                
                for (i=0;i<[objects count];i++){
                    temp=[objects objectAtIndex:i];
                    if (temp.selfId==tempsave.selfId) {
                        NSIndexPath *indexsave=[NSIndexPath indexPathForItem:i inSection:0];
                        indexPath=indexsave;
                        break;
                    }
                }
            

        }
        //-->当前扩展关,执行扩展开
        
        //初始化子Cell的数据,并根据当前选择行的ID,指定它的类Cell
        //NSMutableArray * secondFloorAry = [self createChildCellType:@"2-1" Title:@"2-1" Level:3 SuperId:cellType.selfId];
        //NSMutableArray * secondFloorAry =[[NSMutableArray alloc]initWithObjects:@"12",@"13", nil];
        //当前父Cell的下一个位置
        temp = [objects objectAtIndex:indexPath.row];
        NSMutableArray * secondFloorAry=[[NSMutableArray alloc]init];
        int year=temp.year;
        double xuefenplus,jidianplus;
        double xuefentotal=0,jidiantotal=0;
        int tempindex;
        
        DRow *xuenian=[[DRow alloc]init];
        xuenian.xueqitemp=@"学年";
        xuenian.selfId=-2;
        xuenian.superId=temp.selfId;
        [secondFloorAry addObject:xuenian];
        
        
        for (int k=1; k<=2; k++) {
            NSDictionary *dictionary=[[NSDictionary alloc]init];
            dictionary=[[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat: @"%d-%d-%d",year,year+1,k]];
            if (dictionary!=nil) {
                DRow *xueqi=[[DRow alloc]init];
                if (k==2) {
                    xueqi.xueqitemp=@"春夏";
                    xueqi.selfId=-2;
                    xueqi.superId=temp.selfId;
                }
                if (k==1){
                    xueqi.xueqitemp=@"秋冬";
                    xueqi.selfId=-2;
                    xueqi.superId=temp.selfId;
                }
                [secondFloorAry addObject:xueqi];
            }
            tempindex=[secondFloorAry count]-1;
            jidianplus=0;xuefenplus=0;
            NSEnumerator * enumerator = [dictionary keyEnumerator];
            id tempData;
            Dgrade *temp1=[Dgrade new];
            DRow *temp2=[[DRow alloc]init];
            NSDictionary *olddic=[[NSDictionary alloc]init];
            olddic=[[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%d-%d-%d-old",year,year+1,k]];
            //double jidian;
            while(tempData = [enumerator nextObject]){
                id objectValue = [dictionary objectForKey:tempData];
                if(objectValue != nil){
                    temp1=[NSKeyedUnarchiver unarchiveObjectWithData:objectValue];
                    //[secondFlorAry addObject:temp2];
                    temp2=[[DRow alloc]init];
                    temp2.kechengtemp=temp1.name;
                    //jidian= temp1.grade<95 ? 5.0-(95-temp1.grade)*0.1:5.0;
                    temp2.jidiantemp=[NSString stringWithFormat:@"%.1lf",temp1.jidian];
                    temp2.gradetemp=temp1.grade;
                    temp2.xuefentemp=[NSString stringWithFormat:@"× %.1lf",temp1.xuefen];
                    temp2.superId=temp.selfId;
                    xuefenplus+=temp1.xuefen;
                    jidianplus+=temp1.xuefen*temp1.jidian;
                    if ([olddic objectForKey:temp1.name]==nil) {
                        temp2.isNew=YES;
                    }else{
                        temp2.isNew=NO;
                    }
                    [secondFloorAry addObject:temp2];
                }  
            }
            temp2=[secondFloorAry objectAtIndex:tempindex];
            temp2.xuefentemp=[NSString stringWithFormat:@"× %.1lf",xuefenplus];
            if (xuefenplus!=0) {
                temp2.jidiantemp=[NSString stringWithFormat:@"%.2lf",jidianplus/xuefenplus];
            }else{
                temp2.jidiantemp=[NSString stringWithFormat:@"%.2lf",0.];
            }
            jidiantotal+=jidianplus;
            xuefentotal+=xuefenplus;
        }
        xuenian=[secondFloorAry objectAtIndex:0];
        if (xuefentotal!=0) {
            xuenian.jidiantemp=[NSString stringWithFormat:@"%.2lf",jidiantotal/xuefentotal];
        }else{
            xuenian.jidiantemp=[NSString stringWithFormat:@"%.2lf",0.];
        }
        
        xuenian.xuefentemp=[NSString stringWithFormat:@"× %.1lf",xuefentotal];
        
        int superNextRow = indexPath.row+1;
        //将子Cell的数据放入总数据中,并在UItableView中插入它
        for (int j = 0 ; j<[secondFloorAry count]; j++) {
            //将子Cell的数据放入总数据中
            [objects insertObject:[secondFloorAry objectAtIndex:j] atIndex:superNextRow+j];
            //定位子Cell,将要插入的位置
            NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:superNextRow+j inSection:0];
            /*注意**   将子Cell的数据放入总数据中的坐标位置,要和插入Cell的位置关系是一至的(superNextRow+i)*/
            
            //插入子Cell
            [self.tableView insertRowsAtIndexPaths:@[insertIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        
        //将当前父Cell 的状态修改为 扩展开
        temp.isExpanded = YES;
        nowExpand=indexPath.row;
        
    }
    
}




- (void)login
{
    [self.refreshControl beginRefreshing];
    self.refreshControl.attributedTitle = [[NSAttributedString
                                            alloc]initWithString:@"加载中..."];
    BOOL tempMode = [[NSUserDefaults standardUserDefaults] boolForKey:@"mode"];

    if (tempMode) {
        [self refresh:nil];
    }else {
        NSString *xh=[[NSUserDefaults standardUserDefaults]objectForKey:@"name"];
        NSString *password=[[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
        NSString *urlString = [NSString stringWithFormat:@"http://jwbinfosys.zju.edu.cn/default2.aspx"];
        ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
        [request setPostValue:@"Button1" forKey:@"__EVENTTARGET"];
        [request setPostValue:@"" forKey:@"__EVENTARGUMENT"];
        [request setPostValue:@"dDwxNTc0MzA5MTU4Ozs+RGE82+DpWCQpVjFtEpHZ1UJYg8w=" forKey:@"__VIEWSTATE"];
        [request setPostValue:xh forKey:@"TextBox1"];
        [request setPostValue:password forKey:@"TextBox2"];
        [request setPostValue:@"学生" forKey:@"RadioButtonList1"];
        [request setPostValue:@"submit" forKey:@"_eventId"];
        [request setPostValue:@"" forKey:@"Text1"];
        [request setDefaultResponseEncoding:GB2312_ENCODING];
        [request setDelegate:self];
        [request setDidFinishSelector:@selector(refresh:)];
        [request setDidFailSelector:@selector(requestError:)];
        [request startAsynchronous];
    }
    
}
//- (void) login
- (void) refresh:(ASIFormDataRequest *)request
{
//    NSLog(@"%@", [request responseString]);
    
    //获取年份
    NSDate * senddate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH:mm"];
    NSCalendar * cal=[NSCalendar currentCalendar];
    NSUInteger unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:senddate];
    NSInteger year=[conponent year];
    NSLog(@"%d",year);
    
    [[NSUserDefaults standardUserDefaults]setDouble:0 forKey:@"jsj"];
    [[NSUserDefaults standardUserDefaults]setDouble:0 forKey:@"gtld"];
    [[NSUserDefaults standardUserDefaults]setDouble:0 forKey:@"wxys"];
    [[NSUserDefaults standardUserDefaults]setDouble:0 forKey:@"lswh"];
    [[NSUserDefaults standardUserDefaults]setDouble:0 forKey:@"jjsh"];
    [[NSUserDefaults standardUserDefaults]setDouble:0 forKey:@"kxyj"];
    [[NSUserDefaults standardUserDefaults]setDouble:0 forKey:@"jssj"];
    [[NSUserDefaults standardUserDefaults]setDouble:0 forKey:@"tshx"];
    [[NSUserDefaults standardUserDefaults]setDouble:0 forKey:@"xsyt"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    
    //objects=[[NSMutableArray alloc]init];
    
    
    tempcount=(year-2008+1);
    successcount=0;
    BOOL tempMode = [[NSUserDefaults standardUserDefaults] boolForKey:@"mode"];

    
    for (int i=2008; i<=year; i++) {
//        for (j=1; j<=2; j++) {
//            requestForm = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
//            [requestForm setPostValue:@"dDwyMTQ0OTczMjA5O3Q8O2w8aTwxPjs+O2w8dDw7bDxpPDI+O2k8NT47aTwyMT47aTwyMz47aTwzNz47aTwzOT47aTw0MT47aTw0Mz47PjtsPHQ8dDw7dDxpPDE0PjtAAVxlOzIwMDEtMjAwMjsyMDAyLTIwMDM7MjAwMy0yMDA0OzIwMDQtMjAwNTsyMDA1LTIwMDY7MjAwNi0yMDA3OzIwMDctMjAwODsyMDA4LTIwMDk7MjAwOS0yMDEwOzIwMTAtMjAxMTsyMDExLTIwMTI7MjAxMi0yMDEzOzIwMTMtMjAxNDs+O0A8XGU7MjAwMS0yMDAyOzIwMDItMjAwMzsyMDAzLTIwMDQ7MjAwNC0yMDA1OzIwMDUtMjAwNjsyMDA2LTIwMDc7MjAwNy0yMDA4OzIwMDgtMjAwOTsyMDA5LTIwMTA7MjAxMC0yMDExOzIwMTEtMjAxMjsyMDEyLTIwMTM7MjAxMy0yMDE0Oz4+Oz47Oz47dDx0PHA8cDxsPERhdGFUZXh0RmllbGQ7RGF0YVZhbHVlRmllbGQ7PjtsPHh4cTt4cTE7Pj47Pjt0PGk8Nz47QDxcZTvnp4s75YasO+efrTvmmKU75aSPO+efrTs+O0A8XGU7MXznp4s7MXzlhqw7MXznn607MnzmmKU7MnzlpI87Mnznn607Pj47Pjs7Pjt0PHA8O3A8bDxvbmNsaWNrOz47bDx3aW5kb3cucHJpbnQoKVw7Oz4+Pjs7Pjt0PHA8O3A8bDxvbmNsaWNrOz47bDx3aW5kb3cuY2xvc2UoKVw7Oz4+Pjs7Pjt0PEAwPDs7Ozs7Ozs7Ozs+Ozs+O3Q8QDA8Ozs7Ozs7Ozs7Oz47Oz47dDxAMDw7Ozs7Ozs7Ozs7Pjs7Pjt0PHA8cDxsAVRleHQ7PjtsAVpKRFg7Pj47Pjs7Pjs+Pjs+Pjs+y0ElZ9Hn+SlXToKugoUwAneDL5w=" forKey:@"__VIEWSTATE"];
//            [requestForm setPostValue:[NSString stringWithFormat:@"%d-%d",i,i+1] forKey:@"ddlXN"];
//            if (j==1) {
//                [requestForm setPostValue:@"1|秋" forKey:@"ddlXQ"];//春夏为2|春 秋冬为1|秋
//            }else{
//                [requestForm setPostValue:@"2|春" forKey:@"ddlXQ"];//春夏为2|春 秋冬为1|秋
//            }
//            [requestForm setPostValue:@"按学期查询" forKey:@"Button1"];//Button1为学期 Button5为学年
//            [requestForm setDelegate:self];
//            [requestForm setDidFinishSelector:@selector(siftGrade:)];
//            //[requestForm setDidFailSelector:@selector(requestError:)];
//            [requestForm startAsynchronous];
//
//        }
        
        NSString *urlString = [NSString stringWithFormat:@"http://jwbinfosys.zju.edu.cn/xscj.aspx?xh=%@",[[NSUserDefaults standardUserDefaults]stringForKey:@"name"]];
        if (tempMode) {
//            urlString = @"http://gpazju.sinaapp.com/iGetGrade.php";
            urlString = @"http://gpazju.duapp.com/getGrade2.php";
        }
        NSLog(@"%@", urlString);
        ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
        if (!tempMode) {
            [requestForm setPostValue:@"dDwyMTQ0OTczMjA5O3Q8O2w8aTwxPjs+O2w8dDw7bDxpPDI+O2k8NT47aTwyMT47aTwyMz47aTwzNz47aTwzOT47aTw0MT47aTw0Mz47PjtsPHQ8dDw7dDxpPDE0PjtAPFxlOzIwMDEtMjAwMjsyMDAyLTIwMDM7MjAwMy0yMDA0OzIwMDQtMjAwNTsyMDA1LTIwMDY7MjAwNi0yMDA3OzIwMDctMjAwODsyMDA4LTIwMDk7MjAwOS0yMDEwOzIwMTAtMjAxMTsyMDExLTIwMTI7MjAxMi0yMDEzOzIwMTMtMjAxNDs+O0A8XGU7MjAwMS0yMDAyOzIwMDItMjAwMzsyMDAzLTIwMDQ7MjAwNC0yMDA1OzIwMDUtMjAwNjsyMDA2LTIwMDc7MjAwNy0yMDA4OzIwMDgtMjAwOTsyMDA5LTIwMTA7MjAxMC0yMDExOzIwMTEtMjAxMjsyMDEyLTIwMTM7MjAxMy0yMDE0Oz4+Oz47Oz47dDx0PHA8cDxsPERhdGFUZXh0RmllbGQ7RGF0YVZhbHVlRmllbGQ7PjtsPHh4cTt4cTE7Pj47Pjt0PGk8Nz47QDxcZTvnp4s75YasO+efrTvmmKU75aSPO+efrTs+O0A8XGU7MXznp4s7MXzlhqw7MXznn607MnzmmKU7MnzlpI87Mnznn607Pj47Pjs7Pjt0PHA8O3A8bDxvbmNsaWNrOz47bDx3aW5kb3cucHJpbnQoKVw7Oz4+Pjs7Pjt0PHA8O3A8bDxvbmNsaWNrOz47bDx3aW5kb3cuY2xvc2UoKVw7Oz4+Pjs7Pjt0PEAwPDs7Ozs7Ozs7Ozs+Ozs+O3Q8QDA8Ozs7Ozs7Ozs7Oz47Oz47dDxAMDw7Ozs7Ozs7Ozs7Pjs7Pjt0PHA8cDxsPFRleHQ7PjtsPFpKRFg7Pj47Pjs7Pjs+Pjs+Pjs+y0ElZ9Hn+SlXToKugoUwAneDL5w=" forKey:@"__VIEWSTATE"];
            [requestForm setPostValue:[NSString stringWithFormat:@"%d-%d",i,i+1] forKey:@"ddlXN"];
            //        [requestForm setPostValue:@"2|春" forKey:@"ddlXQ"];//春夏为2|春 秋冬为1|秋
            [requestForm setPostValue:@"按学年查询" forKey:@"Button5"];//Button1为学期 Button5为学年
            [requestForm setDefaultResponseEncoding:GB2312_ENCODING];
            [ASIFormDataRequest setShouldThrottleBandwidthForWWAN: NO];
            requestForm.allowCompressedResponse = YES;
        }else{
            [requestForm setPostValue:[[NSUserDefaults standardUserDefaults]stringForKey:@"name"] forKey:@"stuID"];
            [requestForm setPostValue:[[NSUserDefaults standardUserDefaults]stringForKey:@"password"] forKey:@"password"];
            [requestForm setPostValue:[NSString stringWithFormat:@"%d",i] forKey:@"year"];
            [requestForm setDefaultResponseEncoding:GB2312_ENCODING];
            
        }
        
        
//        [requestForm setResponseEncoding:GB2312_ENCODING];
        [requestForm setDelegate:self];
        [requestForm setDidFinishSelector:@selector(siftGrade:)];
        [requestForm setDidFailSelector:@selector(requestError:)];
        [requestForm startAsynchronous];
    }
    
}

- (void)siftGrade:(ASIFormDataRequest *)requestForm
{
    //successcount++;
    //NSLog(@"%d",tempcount);
//    BOOL tempMode = [[NSUserDefaults standardUserDefaults] boolForKey:@"mode"];
//
//    
//    NSString *result;
//    if (tempMode) {
//        NSData *result1 = [requestForm responseData];
//        result = [[NSString alloc] initWithData:result1 encoding:0x80000632];
//    }else {
//        result = [requestForm responseString];
//    }
    [requestForm setStringEncoding:GB2312_ENCODING];
    NSString *result = [requestForm responseString];
    if ([result length] == 0) {
        
        NSData *result1 = [requestForm responseData];
        result = [[NSString alloc] initWithData:result1 encoding:0x80000632];
        NSLog(@"%@", result);
    }
//    NSString *result = [requestForm responseString];
    //NSLog(@"%@", result);
    NSMutableString *temp=[[NSMutableString alloc]initWithString:result];
    
    NSMutableDictionary *kc1=[[NSMutableDictionary alloc]init];
    NSMutableDictionary *kc2=[[NSMutableDictionary alloc]init];
    Dgrade *kemu;
    NSString *xuenian=[[NSString alloc]init];
    int xueqi;
    NSRange range=[temp rangeOfString:@"补考成绩"];
    NSRange range1=[temp rangeOfString:@"20"];
    if (range.location==NSNotFound||range1.location==NSNotFound) {
        tempcount--;
        if(tempcount==0){
            [self performSelector:@selector(reloadView) withObject:nil];
        }
        return;
    }
    [temp deleteCharactersInRange:NSMakeRange(0, range.location+range.length)];
    range=[temp rangeOfString:@"<td>"];
    //NSLog(@"%@",temp);
    NSData *tempkm=[[NSData alloc]init];
    NSString *haha;
    NSString *detail;
    while (range.location!=NSNotFound) {
        kemu=[Dgrade new];
        [temp deleteCharactersInRange:NSMakeRange(0, range.location+range.length)];
        kemu.kechenghao=[temp substringWithRange:NSMakeRange(0,32)];
        //NSLog(@"%@",kemu.kechenghao);
        xuenian=[kemu.kechenghao substringWithRange:NSMakeRange(1, 9)];
        //NSLog(@"%@",xuenian);
        xueqi=[[kemu.kechenghao substringWithRange:NSMakeRange(11, 11)]intValue];
        //NSLog(@" %d",xueqi);
        //NSLog(@"%@",kemu.kechenghao);
        detail=[kemu.kechenghao substringWithRange:NSMakeRange(17, 1)];
        range=[temp rangeOfString:@"</td><td>"];
        [temp deleteCharactersInRange:NSMakeRange(0, range.location+range.length)];
        range=[temp rangeOfString:@"</td><td>"];
        kemu.name=[temp substringToIndex:range.location];
        //NSLog(@"%@",kemu.name);
        [temp deleteCharactersInRange:NSMakeRange(0, range.location+range.length)];
        range=[temp rangeOfString:@"</td><td>"];
        haha=[[NSString alloc]init];
        haha=[temp substringToIndex:range.location];
        if ([haha isEqualToString:@"&nbsp;"]) {
            kemu.grade=@"0";
        }else{
            kemu.grade=haha;
        }
        [temp deleteCharactersInRange:NSMakeRange(0, range.location+range.length)];
        range=[temp rangeOfString:@"</td><td>"];
        kemu.xuefen=[[temp substringToIndex:range.location] doubleValue];
        [temp deleteCharactersInRange:NSMakeRange(0, range.location+range.length)];
        range=[temp rangeOfString:@"</td><td>"];
        haha=[temp substringToIndex:range.location];

        if ([haha isEqualToString:@"&nbsp;"]) {
            kemu.jidian=0.;
        }else{
            kemu.jidian=[haha doubleValue];
        }
        
        [temp deleteCharactersInRange:NSMakeRange(0, range.location+range.length)];
        if ([detail isEqualToString:@"G"]) {//计算机
            [[NSUserDefaults standardUserDefaults]setDouble:[[NSUserDefaults standardUserDefaults]doubleForKey:@"jsj"]+kemu.xuefen forKey:@"jsj"];
        }
        if ([detail isEqualToString:@"J"]) {//沟通领导
            [[NSUserDefaults standardUserDefaults]setDouble:[[NSUserDefaults standardUserDefaults]doubleForKey:@"gtld"]+kemu.xuefen forKey:@"gtld"];
        }
        if ([detail isEqualToString:@"H"]) {//历史文化
            [[NSUserDefaults standardUserDefaults]setDouble:[[NSUserDefaults standardUserDefaults]doubleForKey:@"lswh"]+kemu.xuefen forKey:@"lswh"];
        }
        if ([detail isEqualToString:@"I"]) {//文学艺术
            [[NSUserDefaults standardUserDefaults]setDouble:[[NSUserDefaults standardUserDefaults]doubleForKey:@"wxys"]+kemu.xuefen forKey:@"wxys"];
        }
        if ([detail isEqualToString:@"L"]) {//经济社会
            [[NSUserDefaults standardUserDefaults]setDouble:[[NSUserDefaults standardUserDefaults]doubleForKey:@"jjsh"]+kemu.xuefen forKey:@"jjsh"];
        }
        if ([detail isEqualToString:@"K"]) {//科学研究
            [[NSUserDefaults standardUserDefaults]setDouble:[[NSUserDefaults standardUserDefaults]doubleForKey:@"kxyj"]+kemu.xuefen forKey:@"kxyj"];
        }
        if ([detail isEqualToString:@"M"]) {//技术设计
            [[NSUserDefaults standardUserDefaults]setDouble:[[NSUserDefaults standardUserDefaults]doubleForKey:@"jssj"]+kemu.xuefen forKey:@"jssj"];
        }
        if ([detail isEqualToString:@"S"]) {//通识核心
            [[NSUserDefaults standardUserDefaults]setDouble:[[NSUserDefaults standardUserDefaults]doubleForKey:@"tshx"]+kemu.xuefen forKey:@"tshx"];
        }
        if ([detail isEqualToString:@"X"]) {//新生研讨
            [[NSUserDefaults standardUserDefaults]setDouble:[[NSUserDefaults standardUserDefaults]doubleForKey:@"xsyt"]+kemu.xuefen forKey:@"xsyt"];
        }
        [[NSUserDefaults standardUserDefaults]synchronize];

        range=[temp rangeOfString:@"<td>"];
        tempkm=[[NSData alloc]init];
        tempkm=[NSKeyedArchiver archivedDataWithRootObject:kemu];//转化成NSData
        if (xueqi==1) {
            [kc1 setObject:tempkm forKey:kemu.name];
        }else{
            [kc2 setObject:tempkm forKey:kemu.name];
        }
        //NSLog(@"%@ %lf %@ %lf",kemu.name,kemu.xuefen,kemu.grade,kemu.jidian);
        if (range.location==NSNotFound) {
            break;
        }
    }
    
    NSDictionary *kcgrade=[[NSDictionary alloc]initWithDictionary:kc1];
    NSDictionary *oldgrade=[[NSDictionary alloc]init];
    oldgrade=[[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@-%d",xuenian,1]];
    [[NSUserDefaults standardUserDefaults]setObject:oldgrade forKey:[NSString stringWithFormat:@"%@-%d-old",xuenian,1]];
    [[NSUserDefaults standardUserDefaults]setObject:kcgrade forKey:[NSString stringWithFormat:@"%@-%d",xuenian,1]];
    
    kcgrade=[[NSDictionary alloc]initWithDictionary:kc2];
    oldgrade=[[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@-%d",xuenian,2]];
    [[NSUserDefaults standardUserDefaults]setObject:oldgrade forKey:[NSString stringWithFormat:@"%@-%d-old",xuenian,2]];
    [[NSUserDefaults standardUserDefaults]setObject:kcgrade forKey:[NSString stringWithFormat:@"%@-%d",xuenian,2]];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    NSLog(@"%@",xuenian);
    //[objects addObject:xuenian];
    //[self performSelectorOnMainThread:@selector(loadAll) withObject:nil waitUntilDone:YES];
    tempcount--;
    if(tempcount==0){
        [self performSelector:@selector(reloadView) withObject:nil];
    }
}


- (void)requestError:(ASIFormDataRequest *)requestForm
{
    if (successcount!=0) {
        return;
    }
    NSError *error = [requestForm error];
    NSLog(@"%@", [error localizedDescription]);
    [[SIAlertView appearance]setTitleFont:[UIFont systemFontOfSize:16]];
    [[SIAlertView appearance]setMessageFont:[UIFont systemFontOfSize:15]];
    [[SIAlertView appearance]setViewBackgroundColor:[UIColor colorWithRed:1. green:1. blue:1. alpha:1.]];
    [[SIAlertView appearance]setButtonFont:[UIFont systemFontOfSize:17]];
    
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"网络错误" andMessage:@"你确定  你联网了吗？"];
    //    [alertView addButtonWithTitle:@"Cancel"
    //                             type:SIAlertViewButtonTypeCancel
    //                          handler:^(SIAlertView *alertView) {
    //                              NSLog(@"Cancel Clicked");
    //                          }];
    [alertView addButtonWithTitle:@"我去看看"
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alertView) {
                              NSLog(@"OK Clicked");
                          }];
    alertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
    alertView.backgroundStyle = SIAlertViewBackgroundStyleSolid;
    [alertView show];
    successcount=1;
    //[self reloadView];
    [self performSelectorOnMainThread:@selector(reloadView) withObject:nil waitUntilDone:NO];
}


@end
