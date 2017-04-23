# QHScreenCAPDemo

### 注意  
在manager的"//!!!"这个注释提示，控制是保存相册还是录屏展示

### 这只是录屏的一个小Demo  
类似直播App里面观看的录屏功能。点击录屏会出现录屏功能，
这里会添加多一个UIWindow来区分需要录制的window，这样可以不把录制功能的控件也录入视频里面。

![image](https://github.com/chenqihui/QHScreenCAPDemo/blob/master/screenshots/QHScreenCAPDemo.gif)

### 说明
这种录屏原理是截图，针对window进行绘制，相当于copy出来，然后进行视频流的拼接，里面的参数设置比较关键，可以参考。
然后这个Demo还没有声音，而实际项目是把声音也合成起来。主要看声音来源，把音频信号收集合成mp3或者其他音频格式，再将两者合成。  
我们看到直播App里面录屏到最后有个合成进度，大致就是这个操作，并且还需将视频上传服务器返回视频播放url。

### 问题
这里需要注意，ASScreenRecorder是使用了截屏的方式获取屏幕的画面。对于使用AVPlayer播放的录屏是黑屏，即截图截不到它的画面。  
还有ReplayKit的也是不行的。所以直播App很多播放端使用的播放器应该不是AVPlayer，而使用IKJPlayer是可以录屏成功哈。

### 参考
首先录屏使用的代码是来自[ASScreenRecorder](https://github.com/alskipp/ASScreenRecorder)  
当然，修改和增加满足录屏业务的一些需求。里面可能保存视频到相册的代码需要适配iOS10，这里暂时没改。
