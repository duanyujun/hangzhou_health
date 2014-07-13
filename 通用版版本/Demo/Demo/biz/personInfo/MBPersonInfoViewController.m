//
//  MBPersonInfoViewController.m
//  Demo
//
//  Created by llbt_wgh on 14-3-24.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "MBPersonInfoViewController.h"
#import "PersonInfoHeadCell.h"
#import "PersonInfoOtherCell.h"
#import "MBIIRequest.h"
#import "AppDelegate.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "MBPresentView.h"
#import "MBTextField.h"
#import "BlockTextPromptAlertView.h"
#import "SoapHelper.h"
#import "MBPersonSetPadViewController.h"
#import "NSDateUtilities.h"
#import "MBLoadingView.h"
@interface MBPersonInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,
UINavigationControllerDelegate,MBTextFieldDelegate>
{
    NSArray *_itemArray ;
    NSMutableDictionary *_allUserDic;
    UITableView*_tableView;
    MBPresentView*_cancelPreseView;
    NSString *_phoneStr;//将要修改的手机号码
    MBLoadingView *_HUD;
}
@end

@implementation MBPersonInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *moblie =[[NSUserDefaults standardUserDefaults]valueForKey:@"MobileNO"];

    _allUserDic =[[NSMutableDictionary alloc]initWithDictionary:[[NSUserDefaults standardUserDefaults]valueForKey:ALLLOGINPEROPLE][moblie] ];
    if (!_allUserDic) {
        _allUserDic =[[NSMutableDictionary alloc]init];
    }

    [_tableView reloadData];
}
//返回到上个页面
-(void)backViewUPloadView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title=@"个人资料";
    if (IOS7_OR_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        UIBarButtonItem *leftBarItem =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backView.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backViewUPloadView)];
        self.navigationItem.leftBarButtonItem=leftBarItem;
    }else
    {
        UIButton *btnLeft =[UIButton buttonWithType:UIButtonTypeCustom];
        btnLeft.frame=CGRectMake(0, 0, 12, 20);
        [btnLeft setBackgroundImage:[UIImage imageNamed:@"backView.png"] forState:UIControlStateNormal];
        [btnLeft addTarget:self action:@selector(backViewUPloadView) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    }

    NSString *moblie =[[NSUserDefaults standardUserDefaults]valueForKey:@"MobileNO"];

    _allUserDic =[[NSUserDefaults standardUserDefaults]valueForKey:ALLLOGINPEROPLE][moblie];

    
    _itemArray =[[NSArray alloc]initWithObjects:@"头像",@"账号",@"用户名",@"绑定手机",@"修改密码", nil];
    
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, kScreenHeight) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=HEX(@"#ffffff");
    [self.view addSubview:_tableView];
    
    _HUD =[[MBLoadingView alloc]init];
    _HUD.canCancel=NO;

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    
    if (section==0||section==1) {
        return 1;
    }else
    {
        return _itemArray.count-1;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section==1) {
        
        static NSString *cellStr =@"PersonInfoHeadCell";
        PersonInfoHeadCell *cell =[tableView dequeueReusableCellWithIdentifier:cellStr];
        if (cell==nil) {
            cell=[[PersonInfoHeadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
            [MBIIRequest getValidationImageForView:cell.rightView withUrlStr:_allUserDic[@"HeadImg"]];

        }
        cell.leftLbl.text=_itemArray[0];
        return  cell;
        
    }
   else  {
       if (indexPath.section==0) {
           static NSString *cellStrAbout =@"PersonInfoOtherCellHelo";
           PersonInfoOtherCell *cell =[tableView dequeueReusableCellWithIdentifier:cellStrAbout];
           if (cell==nil) {
               cell=[[PersonInfoOtherCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStrAbout];
           }
           cell.leftLbl.text =@"当前机构";
           cell.rightLbl.text =MBNonEmptyStringNo_([[NSUserDefaults standardUserDefaults]valueForKey:@"organName"]);
           return cell;
       }
        static NSString *cellStrAbout =@"PersonInfoOtherCell";
        PersonInfoOtherCell *cell =[tableView dequeueReusableCellWithIdentifier:cellStrAbout];
        if (cell==nil) {
            cell=[[PersonInfoOtherCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStrAbout];
        }
        cell.leftLbl.text =_itemArray[indexPath.row+1];
        if (indexPath.row==0) {
            cell.rightLbl.text =_allUserDic[@"UserName"];

        }
        if (indexPath.row==1) {
            cell.rightLbl.text =_allUserDic[@"Name"];

        }if (indexPath.row==2) {
            cell.rightLbl.text =_allUserDic[@"MobileNO"];

        }if (indexPath.row==3) {
            cell.rightLbl.text =_allUserDic[@"Password"];
            cell.rightLbl.text=@"**********";

        }
        NSLog(@"%@",_allUserDic);
        return cell;
    }
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        return 80;
    }
    if (indexPath.section==0) {
        return 40;
    }else
    {
        return 40;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        
        UIActionSheet *sheet =[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选择", nil];
        
        [sheet showInView:[UIApplication sharedApplication].keyWindow];
        
    }else
    {
        if (indexPath.row==2) {
            
            UITextField *textField;
            BlockTextPromptAlertView *alert = [BlockTextPromptAlertView promptWithTitle:@"提示" message:@"请确认您要绑定的手机号码，用该手机号码可以登录" textField:&textField block:^(BlockTextPromptAlertView *alert){
                [alert.textField resignFirstResponder];
                return YES;
            }];
            
            
            [alert setCancelButtonWithTitle:@"取消" block:nil];
            [alert addButtonWithTitle:@"确认" block:^{
                NSLog(@"Text: %@", textField.text);
                if (textField.text.length!=11) {
                    MBAlert(@"手机格式错误");
                    return;
                }
                [self UpdateTel:textField.text];
            }];
            [alert show];
            
        }
        if (indexPath.row==3) {
            MBPersonSetPadViewController *setPad =[[MBPersonSetPadViewController alloc]init];
            UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:setPad];
            setPad.sender=self;
            [self presentViewController:nav animated:YES completion:nil];
        }
    }
}
-(void)goToLoginViewAbout
{
    MBNotLogViewController *notLogin =[[MBNotLogViewController alloc]init];
    UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:notLogin];
    [self presentViewController:nav animated:YES completion:nil];
}
// 绑定手机
-(void)UpdateTel:(NSString *)tel
{
    BOOL isLogin =[[[NSUserDefaults standardUserDefaults]valueForKey:LOGINSTATUS] boolValue];
    if (!isLogin) {
        [self goToLoginViewAbout];
    }else{
    _phoneStr = [tel copy];
    
    NSMutableDictionary *allUserDic =[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults]valueForKey:ALLLOGINPEROPLE]];
    NSString *loginName = [[NSUserDefaults standardUserDefaults]valueForKey:@"MobileNO"];
    NSDictionary *useInfo=[allUserDic valueForKey:loginName];
    
    NSMutableArray *arr=[NSMutableArray array];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_(useInfo[@"UserID"]),@"userID", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:MBNonEmptyStringNo_(tel),@"tel", nil]];
    
    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"UpdateTel"];
    
    __block MBPersonInfoViewController *blockSelf = self;
    
    MBRequestItem*item =[MBRequestItem itemWithMethod:@"UpdateTel" params:@{@"soapMessag":soapMsg}];
    
    [MBIIRequest requestXMLWithItems:@[item] success:^(id JSON) {
        
        
        NSLog(@"%@",[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]);
        
       
        [blockSelf UpdateTelSUccessBack:[[NSString alloc]initWithData:JSON encoding:NSUTF8StringEncoding]];
        
    } failure:^(NSError *error, id JSON) {
        
    }];
    
    }
}

-(void)UpdateTelSUccessBack:(NSString *)string{

    NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:string];
    if ([MBNonEmptyStringNo_(xmlDoc[@"soap:Body"][@"UpdateTelResponse"][@"UpdateTelResult"]) isEqualToString:@"1"]) {
        
        NSMutableDictionary *allUserDic =[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults]valueForKey:ALLLOGINPEROPLE]];
        
        NSString *loginName = [[NSUserDefaults standardUserDefaults]valueForKey:@"MobileNO"];
        NSMutableDictionary *useInfo=[NSMutableDictionary dictionaryWithDictionary:[allUserDic valueForKey:loginName]];
        [useInfo setValue:_phoneStr forKey:@"MobileNO"];
        [allUserDic setValue:useInfo forKey:loginName];
        
        [[NSUserDefaults standardUserDefaults] setValue:allUserDic forKey:ALLLOGINPEROPLE];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [_allUserDic setValue:_phoneStr forKeyPath:@"MobileNO"];
        [_tableView reloadData];
        MBAlert(@"手机号绑定成功");
    }else{
        MBAlert(@"手机号绑定失败，请重新绑定");

    }

}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //Show Photo Library
        @try {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
                UIImagePickerController *imgPickerVC = [[UIImagePickerController alloc] init];
                [imgPickerVC setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                [imgPickerVC.navigationBar setBarStyle:UIBarStyleBlack];
                [imgPickerVC setDelegate:self];
                [imgPickerVC setAllowsEditing:NO];
                //显示Image Picker
                [self presentViewController:imgPickerVC animated:YES completion:nil];
                
            }else {
                NSLog(@"Album is not available.");
            }
        }
        @catch (NSException *exception) {
            //Error
            NSLog(@"Album is not available.");
        }
    }
    if (buttonIndex == 0) {
        //Take Photo with Camera
        @try {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController *cameraVC = [[UIImagePickerController alloc] init];
                [cameraVC setSourceType:UIImagePickerControllerSourceTypeCamera];
                [cameraVC.navigationBar setBarStyle:UIBarStyleBlack];
                [cameraVC setDelegate:self];
                [cameraVC setAllowsEditing:NO];
                for (id sender in [cameraVC.view subviews]) {
                    NSLog(@"%@",[sender class]);
                }
                //显示Camera VC
                [self presentViewController:cameraVC animated:YES completion:nil];
                
            }else {
                NSLog(@"Camera is not available.");
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Camera is not available.");
        }
    }
}

-(void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    [actionSheet resignFirstResponder];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"Image Picker Controller canceled.");
    //Cancel以后将ImagePicker删除
    [self dismissViewControllerAnimated:YES completion:nil];
    //http://42.120.0.83:9301/AccessPath/HeadImageFile/ClientHeadImage/IMG_20140525_101531.jpg
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"Image Picker Controller did finish picking media.");
    //TODO:选择照片或者照相完成以后的处理
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    PersonInfoHeadCell*cell =(PersonInfoHeadCell*)[_tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"%@",cell);
    cell.rightView.image=info[@"UIImagePickerControllerOriginalImage"];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    [_HUD show];
    
    UIImage *upImage = info[@"UIImagePickerControllerOriginalImage"];
    NSString*urlstr=MBNonEmptyStringNo_([[NSUserDefaults standardUserDefaults]valueForKey:@"webAddress"]);

    NSURL *url = [NSURL URLWithString:urlstr];
    NSString *dateStr=[[[NSDate date] dateTimeString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    dateStr = [dateStr stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    dateStr = [dateStr stringByReplacingOccurrencesOfString:@":" withString:@""];
    
    NSLog(@"%@",dateStr);
    
    NSDictionary *dicAbout=@{@"Content-Disposition": @"form-data",
                        @"name": @"file1",
                        @"filename": [NSString stringWithFormat:@"%@_IMG_%@.jpg",_allUserDic[@"UserID"],dateStr]};
    NSLog(@"%@",dicAbout);

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSData *imageData = UIImageJPEGRepresentation(upImage, 0.5);

    NSArray *ursStrArray =[urlstr componentsSeparatedByString:@"/"];
    NSString *hostUrl =[NSString stringWithFormat:@"%@//%@/UpLoadHandler.ashx",ursStrArray[0],ursStrArray[2]];
    NSLog(@"%@",_allUserDic);

    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:hostUrl parameters:dicAbout constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        
        [formData appendPartWithFileData:imageData name:@"file1" fileName:[NSString stringWithFormat:@"%@_IMG_%@.jpg",_allUserDic[@"UserID"],dateStr] mimeType:@"image/jpeg"];
    }];
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
//        NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
//        [_HUD hide];


        
//    }];
    
   
    
    AFHTTPClient * AFhttp = [AFHTTPClient clientWithBaseURL:url];

    AFHTTPRequestOperation * operation = [AFhttp HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        [_allUserDic setValue:MBNonEmptyStringNo_([[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]) forKey:@"HeadImg"];
        NSString *moblie =[[NSUserDefaults standardUserDefaults]valueForKey:@"MobileNO"];
        [[NSUserDefaults standardUserDefaults]setValue:@{moblie: _allUserDic} forKey:ALLLOGINPEROPLE];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [_HUD hide];
        
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:ALLLOGINPEROPLE]);
        NSLog(@"%@",_allUserDic);
        NSLog(@"%@",MBNonEmptyStringNo_([[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]));
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        

    }];
    [operation start];
    
}


@end
