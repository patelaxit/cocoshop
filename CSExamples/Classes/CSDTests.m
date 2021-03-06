/*
 * CSDElement.h
 * cocoshop tests/examples
 *
 * Copyright (c) 2011 Stepan Generalov
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */


#import "CSDTests.h"
#import "CSDReader.h"
#import "CCMenuItemSpriteIndependent.h"

static int sceneIdx=-1;
static NSString *transitions[] = {
	
	@"CSDTest1",
	@"CSDTest2",
	@"CSDTest3",
	@"CSDTest4",
	
};

Class nextAction()
{
	sceneIdx++;
	sceneIdx = sceneIdx % ( sizeof(transitions) / sizeof(transitions[0]) );
	NSString *r = transitions[sceneIdx];
	Class c = NSClassFromString(r);
	return c;
}

Class backAction()
{
	sceneIdx--;
	int total = ( sizeof(transitions) / sizeof(transitions[0]) );
	if( sceneIdx < 0 )
		sceneIdx += total;	
	
	NSString *r = transitions[sceneIdx];
	Class c = NSClassFromString(r);
	return c;
}

Class restartAction()
{
	NSString *r = transitions[sceneIdx];
	Class c = NSClassFromString(r);
	return c;
}


#pragma mark -
#pragma mark Base TestLayer

@implementation TestLayer

+ (id) scene
{
	return [nextAction() node];
}

-(id) init
{
	if( (self=[super init]) ) {
		
		CGSize s = [[CCDirector sharedDirector] winSize];
		
		CCLabelTTF *label = [CCLabelTTF labelWithString:[self title] fontName:@"Arial" fontSize:32];
		[self addChild: label z:1];
		[label setPosition: ccp(s.width/2, s.height-50)];
		
		NSString *subtitle = [self subtitle];
		if( subtitle ) {
			CCLabelTTF *l = [CCLabelTTF labelWithString:subtitle fontName:@"Thonburi" fontSize:16];
			[self addChild:l z:1];
			[l setPosition:ccp(s.width/2, s.height-80)];
		}		
		
		CCMenuItemImage *item1 = [CCMenuItemImage itemFromNormalImage:@"b1.png" selectedImage:@"b2.png" target:self selector:@selector(backCallback:)];
		CCMenuItemImage *item2 = [CCMenuItemImage itemFromNormalImage:@"r1.png" selectedImage:@"r2.png" target:self selector:@selector(restartCallback:)];
		CCMenuItemImage *item3 = [CCMenuItemImage itemFromNormalImage:@"f1.png" selectedImage:@"f2.png" target:self selector:@selector(nextCallback:)];
		
		CCMenu *menu = [CCMenu menuWithItems:item1, item2, item3, nil];
		
		menu.position = CGPointZero;
		item1.position = ccp( s.width/2 - 100,30);
		item2.position = ccp( s.width/2, 30);
		item3.position = ccp( s.width/2 + 100,30);
		[self addChild: menu z:1];	
	}
	
	return self;
}

-(void) restartCallback: (id) sender
{
	CCScene *s = [restartAction() node];
	[[CCDirector sharedDirector] replaceScene: s];
}

-(void) nextCallback: (id) sender
{
	CCScene *s = [nextAction() node];
	[[CCDirector sharedDirector] replaceScene: s];
}

-(void) backCallback: (id) sender
{
	CCScene *s = [backAction() node];
	[[CCDirector sharedDirector] replaceScene: s];
}

-(NSString*) title
{
	return @"No title";
}

-(NSString*) subtitle
{
	return nil;
}
@end


#pragma mark -
#pragma mark CSDTest1

@implementation CSDTest1
-(id) init
{
	if( !( self=[super init]) )
		return nil;
	
	CSDReader *csd = [CSDReader readerWithFile:@"example1.csd"];
	CCNode *aNode = [csd newNode];
	[self addChild: aNode];
	
	// fit node intro screen
	CGSize s = [[CCDirector sharedDirector] winSize];
	aNode.scale = MIN( 1.0f, MIN (s.width / aNode.contentSize.width, s.height / aNode.contentSize.height));
	
	return self;
}

-(NSString *) title
{
	return @"Auto: newNode";
}

@end

@implementation CSDTest2
-(id) init
{
	if( !( self=[super init]) )
		return nil;
	
	// Load spriteSheet & create batchNode
	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"CSDTest2.plist" textureFile:@"CSDTest2.png"];
	CCSpriteBatchNode *batchNode = [CCSpriteBatchNode batchNodeWithFile:@"CSDTest2.png"];
	
	// Create Node from CSD using batchNode
	CSDReader *csd = [CSDReader readerWithFile:@"example1.csd"];
	CCNode *aNode = [csd newNodeWithClass:[CCNode class] usingBatchNode: batchNode];
	[self addChild: aNode];
	
	// fit node intro screen
	CGSize s = [[CCDirector sharedDirector] winSize];
	aNode.scale = MIN( 1.0f, MIN (s.width / aNode.contentSize.width, s.height / aNode.contentSize.height));
	
	return self;
}

-(NSString *) title
{
	return @"Auto: newNode with spriteBatch";
}

-(NSString *) subtitle
{
	return @"Note: isRelativeAnchorPoint not supported.";
}

@end

@implementation CSDTest3
-(id) init
{
	if( !( self=[super init]) )
		return nil;
	
	// Load spriteSheet & create batchNode
	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"CSDTest2.plist" textureFile:@"CSDTest2.png"];
	CCSpriteBatchNode *batchNode = [CCSpriteBatchNode batchNodeWithFile:@"CSDTest2.png"];
	
	// Create Node from CSD using batchNode
	CSDReader *csd = [CSDReader readerWithFile:@"example1.csd"];
	CCNode *aNode = [csd newNodeWithClass:[CCNode class] usingBatchNode: batchNode];
	[self addChild: aNode];
	
	// fit node intro screen
	CGSize s = [[CCDirector sharedDirector] winSize];
	aNode.scale = MIN( 1.0f, MIN (s.width / aNode.contentSize.width, s.height / aNode.contentSize.height));
	
	// Find the Kenny before the bastards.
	CCSprite *kenny = (CCSprite *)[aNode getChildByTag: [csd tagForElementWithName:@"Kenny_png"] ];
	if (!kenny)
	{
		// kenny is a child of batchNode
		kenny = (CCSprite *)[batchNode getChildByTag: [csd tagForElementWithName:@"Kenny_png"] ];
	}
	
	// Spin the Kenny!
	[kenny runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:3.0f angle:360.0f]]];
	
	return self;
}

-(NSString *) title
{
	return @"Node tag by element name.";
}

-(NSString *) subtitle
{
	return @"Kenny should dodge from bastards!";
}

@end


@interface MenuFromCSD : CCNode
{
	ccColor4B savedBGColor_;
}

- (ccColor4B) savedBGColor;

@end

@implementation MenuFromCSD

- (id) init
{
	if ( (self == [super init]) )
	{
		// Setup self from CSD
		CSDReader *csd = [CSDReader readerWithFile:@"test4.csd"];
		[csd setupNode: self];
		
		// save the color and remove the background from self
		savedBGColor_ = [[csd backgroundElement] color];
		[self removeChildByTag: [[csd backgroundElement] tag] cleanup:YES];
		
		// get sprites for buttons ( Note that pressed & normal sprites have different sizes! )
		CCSprite *coconade = (CCSprite *)[self getChildByTag:[csd tagForElementWithName:@"coconade"]];
		CCSprite *coconadePressed = (CCSprite *)[self getChildByTag:[csd tagForElementWithName:@"coconadePressed"]];
		CCSprite *forum = (CCSprite *)[self getChildByTag:[csd tagForElementWithName:@"forum"]];
		CCSprite *forumPressed = (CCSprite *)[self getChildByTag:[csd tagForElementWithName:@"forumPressed"]];
		CCSprite *site = (CCSprite *)[self getChildByTag:[csd tagForElementWithName:@"site"]];
		CCSprite *sitePressed = (CCSprite *)[self getChildByTag:[csd tagForElementWithName:@"sitePressed"]];		
		
		// create menu items
		CCMenuItemSpriteIndependent *coconadeMenuItem = 
			[CCMenuItemSpriteIndependent itemFromNormalSprite: coconade
											   selectedSprite: coconadePressed
														block: ^(id sender) {
															[[UIApplication sharedApplication] openURL: [NSURL URLWithString: @"https://github.com/andrew0/cocoshop/"]]; //<TODO: change to CocoNade URL after rename																									
														}];
		
		CCMenuItemSpriteIndependent *forumMenuItem = 
		[CCMenuItemSpriteIndependent itemFromNormalSprite: forum
										   selectedSprite: forumPressed
													block: ^(id sender) {
														NSLog(@"forum");
														[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.cocos2d-iphone.org/forum"]];																									
													}];
		
		CCMenuItemSpriteIndependent *siteMenuItem = 
		[CCMenuItemSpriteIndependent itemFromNormalSprite: site
										   selectedSprite: sitePressed
													block: ^(id sender) {
														NSLog(@"site");
														[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.cocos2d-iphone.org/"]];																									
													}];
		
		//create and add menu
		CCMenu *menu = [CCMenu menuWithItems:coconadeMenuItem, forumMenuItem, siteMenuItem, nil];
		[self addChild: menu];
	}
	
	return self;
}

- (ccColor4B) savedBGColor
{
	return savedBGColor_;
}

@end


@implementation CSDTest4

-(id) init
{
	if( !( self=[super init]) )
		return nil;
	
	// Add Custom Node
	MenuFromCSD *aNode = [MenuFromCSD node];
	[self addChild: aNode];
	
	// fit node intro screen
	CGSize s = [[CCDirector sharedDirector] winSize];
	aNode.scale = MIN( 1.0f, MIN (s.width / aNode.contentSize.width, s.height / aNode.contentSize.height));
	
	// place it on center
	aNode.anchorPoint = ccp(0.5f,0.5f);
	aNode.position = ccp(s.width / 2.0f,s.height / 2.0f);
	
	// Add fullscreen background with color from CSD
	CCLayerColor *bgLayer = [CCLayerColor layerWithColor: [aNode savedBGColor]];
	[self addChild: bgLayer z: -1];	
	
	return self;
}

-(NSString *) title
{
	return @"CSD Menus";
}

-(NSString *) subtitle
{
	return @"Press the button!";
}

@end
