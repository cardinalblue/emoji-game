//
//  Game.h
//  emoji-game
//
//  Created by Tyler Barth on 2013-10-04.
//  Copyright (c) 2013年 cblue. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Game;
@protocol GameDelegate <NSObject>
-(void) game:(Game*)game;
@end

@interface Game : NSObject

@property (nonatomic, readonly) NSString *currentBoard;
@property (nonatomic, readonly) NSString *currentGuess;

-(void)makeGuess:(NSString*)guess;
-(void)updateBoard:(NSString*)board;

// As soon as you create a game, it begins polling and
// will start updating your delegate
+(Game *) gameWithURL:(NSURL*)url andDelegate:(id<GameDelegate>)delegate;

@end
