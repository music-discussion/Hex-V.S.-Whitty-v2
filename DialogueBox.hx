package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;
	var portraitLeftALT:FlxSprite;
	var portraitRightALT:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'carefree':
				FlxG.sound.playMusic(Paths.music('carefree-dialogue-loop'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.1);
			case 'censory-overload' | 'terminate':
				FlxG.sound.playMusic(Paths.music('spooky_ambience', 'qt'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.47);
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		box = new FlxSprite(-20, 45);
		
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			case 'roses':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);

			case 'thorns':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);

				var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/spiritFaceForward'));
				face.setGraphicSize(Std.int(face.width * 6));
				add(face);

			//QT / Robot Week
			case 'carefree' | 'careless' | 'cessation':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking');
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByPrefix('normal', 'speech bubble normal', 24, false);

				//fix scale and offset (probably a better way to do this, but I don't know what the fuck is going on in here) -Haz
				box.setGraphicSize(Std.int(box.width * 0.2));
				box.updateHitbox();
				box.y += 340;

				box.scrollFactor.set(1);

			case 'censory-overload' | 'terminate': //Why are they seperated? ...Erm...  ¯\_(ツ)_/¯ //cause haz is a fucking idiot -discussions
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking');
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByPrefix('normal', 'speech bubble normal', 24, false);

				//fix scale and offset (probably a better way to do this, but I don't know what the fuck is going on in here) -Haz |, you shouldn't. shit at coding -Disucssions
				box.setGraphicSize(Std.int(box.width * 0.2));
				box.updateHitbox();
				box.y += 340;
				box.scrollFactor.set(1);
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;
		
		//Loading portraits for Custom Week -Haz
		if (PlayState.SONG.song.toLowerCase()=='carefree' || PlayState.SONG.song.toLowerCase()=='careless' || PlayState.SONG.song.toLowerCase()=='censory-overload' || PlayState.SONG.song.toLowerCase()=='terminate' || PlayState.SONG.song.toLowerCase()=='cessation')
			{
				//This is awful. There is most definitely a better way of doing this but I can't be bothered to find, learn, and use it. Don't be like me, do it the proper way (whatever that is)-Haz
				if(PlayState.SONG.song.toLowerCase()=='censory-overload'){ //Defining portraits for Censory-Overload, SOON TO BE FUCKING ADDED
					portraitLeft = new FlxSprite(-20, 50);
					portraitLeft.frames = Paths.getSparrowAtlas('ui/roboPortait', 'qt');
					portraitLeft.animation.addByPrefix('enter', 'robo_potrait', 24, false);
					//portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
					portraitLeft.updateHitbox();
					portraitLeft.scrollFactor.set(1);
					add(portraitLeft);
					portraitLeft.visible = false;
					portraitRight = new FlxSprite(0, 50);
					portraitRight.frames = Paths.getSparrowAtlas('ui/bfPortrait', 'qt');
					portraitRight.animation.addByPrefix('enter', 'bf_portrait', 24, false);
					//portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9)); //Lmao, this breaks shit so I disabled it -Haz
					portraitRight.updateHitbox();
					portraitRight.scrollFactor.set(1);
					add(portraitRight);
					portraitRight.visible = false;
	
					portraitLeftALT = new FlxSprite(0, 50);
					portraitLeftALT.frames = Paths.getSparrowAtlas('ui/emptyPortrait', 'qt');
					portraitLeftALT.animation.addByPrefix('enter', 'nothingEnter', 24, false);
					add(portraitLeftALT);
					portraitLeftALT.visible = false;
					portraitRightALT = new FlxSprite(0, 50);
					portraitRightALT.frames = Paths.getSparrowAtlas('ui/emptyPortrait', 'qt');
					portraitRightALT.animation.addByPrefix('enter', 'nothingEnter', 24, false);
					add(portraitRightALT);
					portraitRightALT.visible = false;
	
				}else if(PlayState.SONG.song.toLowerCase()=='careless'){ //Defining portraits for Careless, WHYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY
					portraitLeft = new FlxSprite(-20, 50);
					portraitLeft.frames = Paths.getSparrowAtlas('ui/qtPortaitALT', 'qt');
					portraitLeft.animation.addByPrefix('enter', 'finished_qt_sprite_potrait', 24, false);
					//portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
					portraitLeft.updateHitbox();
					portraitLeft.scrollFactor.set(1);
					add(portraitLeft);
					portraitLeft.visible = false;
					portraitRight = new FlxSprite(0, 50);
					portraitRight.frames = Paths.getSparrowAtlas('ui/bfPortrait', 'qt');
					portraitRight.animation.addByPrefix('enter', 'bf_portrait', 24, false);
					//portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9)); //Lmao, this breaks shit so I disabled it -Haz
					portraitRight.updateHitbox();
					portraitRight.scrollFactor.set(1);
					add(portraitRight);
					portraitRight.visible = false;
	
					portraitLeftALT = new FlxSprite(0, 50);
					portraitLeftALT.frames = Paths.getSparrowAtlas('ui/emptyPortrait', 'qt');
					portraitLeftALT.animation.addByPrefix('enter', 'nothingEnter', 24, false);
					add(portraitLeftALT);
					portraitLeftALT.visible = false;
					portraitRightALT = new FlxSprite(0, 50);
					portraitRightALT.frames = Paths.getSparrowAtlas('ui/emptyPortrait', 'qt');
					portraitRightALT.animation.addByPrefix('enter', 'nothingEnter', 24, false);
					add(portraitRightALT);
					portraitRightALT.visible = false;
					
				}else if(PlayState.SONG.song.toLowerCase()=='terminate'){ //Defining portraits for Terminate, yes we love this 
					portraitLeft = new FlxSprite(-20, 50);
					portraitLeft.frames = Paths.getSparrowAtlas('ui/roboPortait', 'qt');
					portraitLeft.animation.addByPrefix('enter', 'robo_potrait', 24, false);
					portraitLeft.updateHitbox();
					portraitLeft.scrollFactor.set(1);
					add(portraitLeft);
					portraitLeft.visible = false;
	
					portraitRight = new FlxSprite(0, 50);
					portraitRight.frames = Paths.getSparrowAtlas('ui/bfPortrait', 'qt');
					portraitRight.animation.addByPrefix('enter', 'bf_portrait', 24, false);
					portraitRight.updateHitbox();
					portraitRight.scrollFactor.set(1);
					add(portraitRight);
					portraitRight.visible = false;
	
					portraitLeftALT = new FlxSprite(0, 82);
					portraitLeftALT.frames = Paths.getSparrowAtlas('ui/gfPortrait', 'qt');
					portraitLeftALT.animation.addByPrefix('enter', 'gf_portrait', 24, false);
					portraitLeftALT.updateHitbox();
					portraitLeftALT.scrollFactor.set(1);
					add(portraitLeftALT);
					portraitLeftALT.flipX = true;
					portraitLeftALT.visible = false;
	
					portraitRightALT = new FlxSprite(0, 50);
					portraitRightALT.frames = Paths.getSparrowAtlas('ui/qtPortait', 'qt');
					portraitRightALT.animation.addByPrefix('enter', 'finished_qt_sprite_potrait', 24, false);
					portraitRightALT.updateHitbox();
					portraitRightALT.scrollFactor.set(1);
					add(portraitRightALT);
					portraitRightALT.flipX = true;
					portraitRightALT.visible = false;
				}
				else if(PlayState.SONG.song.toLowerCase()=='cessation'){ //Defining portraits for Cessation (ending) soon to have a cover
					portraitLeft = new FlxSprite(-20, 50);
					portraitLeft.frames = Paths.getSparrowAtlas('ui/roboFUTUREPortait');
					portraitLeft.animation.addByPrefix('enter', 'robo_potraitALT', 24, false);
					portraitLeft.updateHitbox();
					portraitLeft.scrollFactor.set(1);
					add(portraitLeft);
					portraitLeft.visible = false;
	
					portraitRight = new FlxSprite(0, 50);
					portraitRight.frames = Paths.getSparrowAtlas('ui/bfPortrait');
					portraitRight.animation.addByPrefix('enter', 'bf_portrait', 24, false);
					portraitRight.updateHitbox();
					portraitRight.scrollFactor.set(1);
					add(portraitRight);
					portraitRight.visible = false;
	
					portraitLeftALT = new FlxSprite(-20, 50);
					portraitLeftALT.frames = Paths.getSparrowAtlas('ui/qtPortait');
					portraitLeftALT.animation.addByPrefix('enter', 'finished_qt_sprite_potrait', 24, false);
					portraitLeftALT.updateHitbox();
					portraitLeftALT.scrollFactor.set(1);
					add(portraitLeftALT);
					portraitLeftALT.visible = false;
	
					portraitRightALT = new FlxSprite(0, 60);
					portraitRightALT.frames = Paths.getSparrowAtlas('ui/gfPortrait');
					portraitRightALT.animation.addByPrefix('enter', 'gf_portrait', 24, false);
					portraitRightALT.updateHitbox();
					portraitRightALT.scrollFactor.set(1);
					add(portraitRightALT);
					portraitRightALT.visible = false;
				}
				else{ //Pretty sure this is for Carefree, which doesn't exist in this mod
					portraitLeft = new FlxSprite(-20, 50);
					portraitLeft.frames = Paths.getSparrowAtlas('ui/qtPortait');
					portraitLeft.animation.addByPrefix('enter', 'finished_qt_sprite_potrait', 24, false);
					//portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
					portraitLeft.updateHitbox();
					portraitLeft.scrollFactor.set(1);
					add(portraitLeft);
					portraitLeft.visible = false;
	
					portraitRight = new FlxSprite(0, 50);
					portraitRight.frames = Paths.getSparrowAtlas('ui/bfPortrait');
					portraitRight.animation.addByPrefix('enter', 'bf_portrait', 24, false);
					//portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9)); //Lmao, this breaks shit so I disabled it -Haz
					portraitRight.updateHitbox();
					portraitRight.scrollFactor.set(1);
					add(portraitRight);
					portraitRight.visible = false;
	
					portraitLeftALT = new FlxSprite(0, 50);
					portraitLeftALT.frames = Paths.getSparrowAtlas('ui/emptyPortrait');
					portraitLeftALT.animation.addByPrefix('enter', 'nothingEnter', 24, false);
					add(portraitLeftALT);
					portraitLeftALT.visible = false;
					portraitRightALT = new FlxSprite(0, 50);
					portraitRightALT.frames = Paths.getSparrowAtlas('ui/emptyPortrait');
					portraitRightALT.animation.addByPrefix('enter', 'nothingEnter', 24, false);
					add(portraitRightALT);
					portraitRightALT.visible = false;
				}
			}
			else {
		
		portraitLeft = new FlxSprite(-20, 40);
		portraitLeft.frames = Paths.getSparrowAtlas('weeb/senpaiPortrait');
		portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
		portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		add(portraitLeft);
		portraitLeft.visible = false;

		portraitRight = new FlxSprite(0, 40);
		portraitRight.frames = Paths.getSparrowAtlas('weeb/bfPortrait');
		portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
		portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;
		}

		box.screenCenter(X);
		portraitLeft.screenCenter(X);

		if (PlayState.SONG.song.toLowerCase()=='carefree' || PlayState.SONG.song.toLowerCase()=='careless' || PlayState.SONG.song.toLowerCase()=='censory-overload'){
			box.x+=50; //Scuffed, but oh well -Haz
			portraitLeft.y += 110;
			portraitLeft.x -= 400;
			portraitRight.y += 160;
			portraitRight.x += 800;
		}
		if(PlayState.SONG.song.toLowerCase()=='terminate' || PlayState.SONG.song.toLowerCase()=='cessation'){
			box.x+=50;
			portraitLeft.y += 110;
			portraitLeft.x -= 400;
			portraitLeftALT.y += 110;
			portraitLeftALT.x -= 400;
			portraitRight.y += 160;
			portraitRight.x += 800;
			portraitRightALT.y += 160;
			portraitRightALT.x += 800;
		}

		handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox'));
		add(handSelect);


		if (!talkingRight)
		{
			// box.flipX = true;
		}

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'Pixel Arial 11 Bold';
		dropText.color = 0xFFD89494;
		add(dropText);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'Pixel Arial 11 Bold';
		swagDialogue.color = 0xFF3F2021;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.color = FlxColor.BLACK;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (PlayerSettings.player1.controls.ACCEPT && dialogueStarted == true)
		{
			remove(dialogue);
				
			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns')
						FlxG.sound.music.fadeOut(2.2, 0);

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						portraitLeft.visible = false;
						portraitRight.visible = false;
						swagDialogue.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);

		if(PlayState.SONG.song.toLowerCase()=='terminate' || PlayState.SONG.song.toLowerCase()=='cessation')
			{
				switch (curCharacter)
				{
					case 'kb': //Left
						box.flipX = true;
						portraitRight.visible = false;
						portraitLeftALT.visible = false;
						portraitRightALT.visible = false;
						if (!portraitLeft.visible) //No need to re-enter if already visible.
						{
							portraitLeft.visible = true;
							portraitLeft.animation.play('enter');
						}
					case 'hex': //Left
						box.flipX = true;
						portraitRight.visible = false;
						portraitLeftALT.visible = false;
						portraitRightALT.visible = false;
						if (!portraitLeft.visible) //No need to re-enter if already visible.
						{
							portraitLeft.visible = true;
							portraitLeft.animation.play('enter');
						}
					case 'gf': //RightALT
						box.flipX = false;
						portraitRight.visible = false;
						portraitLeftALT.visible = false;
						portraitLeft.visible = false;
						if (!portraitRightALT.visible) //No need to re-enter if already visible.
						{
							portraitRightALT.visible = true;
							portraitRightALT.animation.play('enter');
						}
					case 'bf': //Right
						box.flipX = false;
						portraitLeft.visible = false;
						portraitLeftALT.visible = false;
						portraitRightALT.visible = false;
						if (!portraitRight.visible) //No need to re-enter if already visible.
						{
							portraitRight.visible = true;
							portraitRight.animation.play('enter');
						}
					case 'qt': //LeftALT
						box.flipX = true;
						portraitLeft.visible = false;
						portraitRightALT.visible = false;
						portraitRight.visible = false;
						if (!portraitLeftALT.visible) //No need to re-enter if already visible.
						{
							portraitLeftALT.visible = true;
							portraitLeftALT.animation.play('enter');
						}
				}
			}
			else
			{
				switch (curCharacter)
				{
					case 'dad':
						//For flipping custom speech bubble.
						if(PlayState.SONG.song.toLowerCase()=='carefree' || PlayState.SONG.song.toLowerCase()=='careless' || PlayState.SONG.song.toLowerCase()=='censory-overload')
							box.flipX = true;
						portraitRight.visible = false;
						if (!portraitLeft.visible) //No need to re-enter if already visible.
						{
							portraitLeft.visible = true;
							portraitLeft.animation.play('enter');
						}
					case 'bf':
						if(PlayState.SONG.song.toLowerCase()=='carefree' || PlayState.SONG.song.toLowerCase()=='careless' || PlayState.SONG.song.toLowerCase()=='censory-overload')
							box.flipX = false;
						portraitLeft.visible = false;
						if (!portraitRight.visible) //No need to re-enter if already visible.
						{
							portraitRight.visible = true;
							portraitRight.animation.play('enter');
						}
				}
			}
		}
//	} wtf did i do now

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}
