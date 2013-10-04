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
-(void)gameUpdated:(Game*)game;
@end

@interface Game : NSObject

@property (nonatomic, readwrite) BOOL        isConnected;

@property (nonatomic, weak)id<GameDelegate> delegate;

@property (nonatomic, copy)      NSString    *question;
@property (nonatomic, copy)      NSString    *answer;
@property (nonatomic, copy)      NSString    *lastGuess;
@property (nonatomic, readwrite) NSInteger   guessesCount;
@property (nonatomic, copy)      NSString    *board;
@property (nonatomic, readwrite) BOOL        isGuessed;

- (id)initNewGame:(BOOL)newGame isGuesser:(BOOL)isGuesser;

-(void)makeGuess:(NSString *)guess;
-(void)updateBoard:(NSString *)board;


@end
