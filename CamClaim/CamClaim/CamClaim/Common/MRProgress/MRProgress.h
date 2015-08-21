//
//  MRProgress.h
//  MRProgress
//
//  Created by Marius Rackwitz on 20.10.13.
//  Copyright (c) 2013 Marius Rackwitz. All rights reserved.
//

#import "MRActivityIndicatorView.h"
#import "MRCircularProgressView.h"
#import "MRIconView.h"
#import "MRNavigationBarProgressView.h"
#import "MRProgressOverlayView.h"



/*
用以下其中一种方式来添加进度条：

// Block whole window
[MRProgressOverlayView showOverlayAddedTo:self.window animated:YES];

// Block only the navigation controller
[MRProgressOverlayView showOverlayAddedTo:self.navigationController.view animated:YES];

// Block only the view
[MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];

// Block a custom view
[MRProgressOverlayView showOverlayAddedTo:self.imageView animated:YES];
Simply dismiss after complete your task:

隐藏进度条：
[MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
*/