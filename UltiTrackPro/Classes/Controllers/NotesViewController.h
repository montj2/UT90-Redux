//
//  NotesViewController.h
//  UltiTrack90
//
//  Created by James Montgomery on 9/30/12.
//  Copyright (c) 2012 James Montgomery. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NotesViewControllerDelegate <NSObject>

- (void)notesTextViewDidFinishEditingText:(NSString *)text forSender:(NSInteger)myInt;

@end

@interface NotesViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *notesTextView;
@property (nonatomic, copy) NSString *textFromParent;
@property (nonatomic, assign) NSInteger whoSentMe; //which textview called this view
@property (nonatomic, weak) id <NotesViewControllerDelegate> delegate;
@end
