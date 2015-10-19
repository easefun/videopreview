//
//  DetailViewController.m
//  videopreview
//
//  Created by seanwong on 10/18/15.
//  Copyright © 2015 easefun. All rights reserved.
//

#import "DetailViewController.h"
#import "PLVMoviePlayerController.h"

@interface DetailViewController ()

@property (nonatomic, strong) PLVMoviePlayerController *videoPlayer;

@property (nonatomic, strong)  UIActivityIndicatorView * indicatorView;

@end

@implementation DetailViewController

- (void) moviePlayBackDidFinish:(NSNotification*)notification
{
    
    
}
- (void)dealloc
{
    [self cancelObserver];
    
}
- (void)cancelObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void) playerLoadStateDidChange:(NSNotification*)notification
{
    MPMoviePlayerController *moviePlayer = [notification object];
    if ([moviePlayer loadState] != MPMovieLoadStateUnknown) {

        [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
        [self.indicatorView stopAnimating];
    }
    
}

-(void)enteredFullscreen:(NSNotification*)notification{
    [self.videoPlayer play];
}
-(void)viewDidDisappear:(BOOL)animated {
    [self.videoPlayer pause];
    [super viewDidDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.videoPlayer play];
}
- (void)viewDidLoad {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.navigationController setTitle:self.video.title];
    self.videoPlayer = [[PLVMoviePlayerController alloc]initWithVid:self.video.vid];
    [self.view addSubview:self.videoPlayer.view];
    
    [self.videoPlayer.view setFrame:CGRectMake(self.view.frame.origin.x,self.navigationController.view.frame.origin.y,self.view.frame.size.width,240)];
    
    
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.videoPlayer.view.frame.size.width/2-10, self.videoPlayer.view.frame.size.height/2-10, 20, 20)];
    
    [self.indicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    
    [self.view addSubview:self.indicatorView];

    [self.indicatorView startAnimating];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerLoadStateDidChange:)
                                                 name:MPMoviePlayerLoadStateDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enteredFullscreen:) name:MPMoviePlayerDidEnterFullscreenNotification object:nil];

    
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCellIdentifier"];
    
    UIImageView *faceImageView = (UIImageView *)[cell viewWithTag:101];
    [faceImageView setImage:[UIImage imageNamed:@"face.jpg"]];
    
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:102];
    nameLabel.text = @"name";
    
    UILabel *commentLabel = (UILabel *)[cell viewWithTag:103];
    commentLabel.text = @"视频不错，继续加油";
    
    
    
    
    
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
