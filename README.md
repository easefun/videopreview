# 3D touch demo


<a href="http://demo.polyv.net/data/touch.html" target="_blank"><img src="http://img.videocc.net/uimage/s/sl8da4jjbx/9/sl8da4jjbx03e781777b590b733b5929_2_b.jpg" alt="alt text" width="200px" height="330px"></a>

利用3D touch的“Peek and Pop”实现视频预览
--
iOS9和iPhone6s/6s Plus的发布，比较令人关注的一个新特性就是3D touch。

本案在视频列表的UITableView里面，用3D touch的Peek and Pop实现了点开视频播放的详情DetailViewController之前，先做个视频预览。

事先创建
```objective-c
@interface MainViewController : UITableViewController

```
实现Table view data source加载一些演示用的视频列表。


在viewDidLoad方法里面，判断当前使用设备是否支持3D touch

```objective-c
 if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        
        [self registerForPreviewingWithDelegate:(id)self sourceView:self.view];
        
        
    }
```
这一步通过registerForPreviewingWithDelegate方法，将当前viewcontroller增加预览功能。
接下来需要实现预览功能的两个代理方法：
```objective-c
# pragma mark - 3D Touch Delegate

- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    
    //通过当前点按的位置拿到当前tableview的行号，此处实现peek动作
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    Video *video = [_videolist objectAtIndex:indexPath.row];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                @"Main" bundle:[NSBundle mainBundle]];
                                
    DetailViewController *detailViewController = [storyboard instantiateViewControllerWithIdentifier:@"detailViewController"];
    //传递当前选择的视频信息
    detailViewController.video = video;
    //获取当前选择的表单元格
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    //预览窗口只截取详情视频detailViewController的上半部分，高度设置为240
    detailViewController.preferredContentSize =(CGSize){0, 240};
    
    //除了这个单元格，需要模糊其它位置
    previewingContext.sourceRect = cell.frame;

    
    return detailViewController;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    //继续按进来则实现pop的动作，弹出详情页
    [self showViewController:viewControllerToCommit sender:self];
    
}

```




