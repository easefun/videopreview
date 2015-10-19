//
//  MainViewController.m
//  videopreview
//
//  Created by seanwong on 10/18/15.
//  Copyright © 2015 easefun. All rights reserved.
//

#import "MainViewController.h"
#import "Video.h"
#import "DetailViewController.h"
@interface MainViewController (){
    NSMutableArray *_videolist;
}

@end

@implementation MainViewController

- (void)viewDidLoad {
    
    _videolist = [NSMutableArray array];
    //[self.tableView setContentInset:UIEdgeInsetsMake(20,0,0,0)];

    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://demo.polyv.net/data/video.js"]];
    [request setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if(data!=nil){
            NSDictionary * jsondata = [NSJSONSerialization
                                       JSONObjectWithData:data
                                       options:0
                                       error:&error];
            
            NSMutableArray *videos = [jsondata objectForKey:@"data"];
            for(int i=0;i<videos.count;i++){
                NSDictionary*item = [videos objectAtIndex:i];
                Video *video = [[Video alloc] init];
                video.title = [item objectForKey:@"title"];
                video.vid = [item objectForKey:@"vid"];
                video.duration = [item objectForKey:@"duration"];
                video.piclink = [item objectForKey:@"first_image"];
                
                [_videolist addObject:video];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
        
        
        
        
        
    }] resume];
    
    
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        
        [self registerForPreviewingWithDelegate:(id)self sourceView:self.view];
        
        
    }

    
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_videolist count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 40;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    Video*video = [_videolist objectAtIndex:indexPath.row];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UILabel *label_title =[[UILabel   alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width, 20)] ;
        label_title.tag = 101;
        label_title.text = video.title;
        [cell.contentView addSubview:label_title];
        
               
        
    }else{
        UILabel *label_title = (UILabel*)[cell viewWithTag:101];
        label_title.text = video.title;
        
    }
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Video *video = [_videolist objectAtIndex:indexPath.row];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                @"Main" bundle:[NSBundle mainBundle]];
    
    DetailViewController *detailViewController = [storyboard instantiateViewControllerWithIdentifier:@"detailViewController"];
    detailViewController.video = video;
    [self.navigationController pushViewController:detailViewController animated:YES];
    
  
}


# pragma mark - 3D Touch Delegate

- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    Video *video = [_videolist objectAtIndex:indexPath.row];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                @"Main" bundle:[NSBundle mainBundle]];
    DetailViewController *detailViewController = [storyboard instantiateViewControllerWithIdentifier:@"detailViewController"];
    detailViewController.video = video;
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    detailViewController.preferredContentSize =(CGSize){0, 240};
    previewingContext.sourceRect = cell.frame;

    
    
    
    
    
    return detailViewController;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self showViewController:viewControllerToCommit sender:self];
    
}


@end
