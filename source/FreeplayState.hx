package;

import flixel.input.gamepad.FlxGamepad;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;


#if windows
import Discord.DiscordClient;
#end

using StringTools;

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	var curSelected:Int = 0;
	var curDifficulty:Int = 1;

	var scoreText:FlxText;
	var comboText:FlxText;
	var diffText:FlxText;
	var randomText:FlxText;
	var randomModeText:FlxText;
	var maniaText:FlxText;
	var flipModeText:FlxText;
	var bothSideText:FlxText;
	var randomManiaText:FlxText;
	var noteTypesText:FlxText;

	var keyAmmo:Array<Int> = [4, 6, 9, 5, 7, 8, 1, 2, 3];
	var randMania:Array<String> = ["Off", "Low Chance", "Medium Chance", "High Chance"];
	var randNoteTypes:Array<String> = ["Off", "Low Chance", "Medium Chance", "High Chance", 'Unfair'];

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;
	var combo:String = '';

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];

	override function create()
	{
		var initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));

		for (i in 0...initSonglist.length)
		{
			var data:Array<String> = initSonglist[i].split(':');
			songs.push(new SongMetadata(data[0], Std.parseInt(data[2]), data[1]));
		}

		#if desktop

		#else
		if (!FlxG.sound.music.playing)
			{
				TitleState.musicShit();
			}
		#end

		/* 
			if (FlxG.sound.music != null)
			{
				if (!FlxG.sound.music.playing)
					TitleState.musicShit();
			}
		 */

		 #if windows
		 // Updating Discord Rich Presence
		 DiscordClient.changePresence("In the Freeplay Menu", null);
		 #end

		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end

		/*
		Terminate:robot:7
Censory-Overload:robot:7
Termination:robot:7
*/

			if(FlxG.save.data.terminateWon || isDebug) {
				songs.push(new SongMetadata('Terminate', 7, 'robot'));
				songs.push(new SongMetadata('Censory-Overload', 7, 'robot'));
			}

			if(FlxG.save.data.terminationUnlocked && FlxG.save.data.powerWon || isDebug)
				songs.push(new SongMetadata('Termination', 7, 'hex'));

			if(FlxG.save.data.terminateWon && FlxG.save.data.didCensory || isDebug) {
				songs.push(new SongMetadata('Power-Link', 7, 'hex'));
			}
			if (FlxG.save.data.terminationBeaten && FlxG.save.data.powerWon || isDebug)
				songs.push(new SongMetadata('Final-Destination', 7, 'hex'));

		// LOAD MUSIC

		// LOAD CHARACTERS

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBGBlue'));
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false, true);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		// scoreText.autoSize = false;
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		// scoreText.alignment = RIGHT;

		var scoreBG:FlxSprite = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		comboText = new FlxText(diffText.x + 100, diffText.y, 0, "", 24);
		comboText.font = diffText.font;
		add(comboText);

		add(scoreText);
		add(randomText);
		add(randomModeText);
		add(maniaText);
		add(flipModeText);
		add(bothSideText);
		add(randomManiaText);
		add(noteTypesText);

		changeSelection();
		changeDiff();

		// FlxG.sound.playMusic(Paths.music('title'), 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);
		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";
		// add(selector);

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */

		super.create();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter));
	}

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['dad'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);

			if (songCharacters.length != 1)
				num++;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = "PERSONAL BEST:" + lerpScore;
		comboText.text = combo + '\n';

		var upP = FlxG.keys.justPressed.UP;
		var downP = FlxG.keys.justPressed.DOWN;
		var accepted = controls.ACCEPT;

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.DPAD_UP)
			{
				changeSelection(-1);
			}
			if (gamepad.justPressed.DPAD_DOWN)
			{
				changeSelection(1);
			}
			if (gamepad.justPressed.DPAD_LEFT)
			{
				changeDiff(-1);
			}
			if (gamepad.justPressed.DPAD_RIGHT)
			{
				changeDiff(1);
			}
		}

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		var songNameLow = songs[curSelected].songName.toLowerCase();

		if(!(songNameLow == "termination" || songNameLow== "power-link" 
		|| songNameLow== "terminate" || songNameLow== "final-destination" || songNameLow=="censory-overload"))
		{	//Only allow the difficulty to be changed if the song isn't termination or any listed above.
		if (controls.LEFT_P)
			changeDiff(-1);
		if (controls.RIGHT_P)
			changeDiff(1);
		}

		if (controls.BACK)
		{
			FlxG.switchState(new MainMenuState());
		}

		if (controls.ACCEPT)
		{
				var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);

				trace(poop);

				PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
				PlayState.isStoryMode = false;
				PlayState.storyDifficulty = curDifficulty;
				PlayState.storyWeek = songs[curSelected].week;
				trace('CUR WEEK' + PlayState.storyWeek);
				LoadingState.loadAndSwitchState(new PlayState());
		}

		if(songNameLow=="termination") //somehow this shit works?/??
		{
			diffText.text = "VERY UNFAIR";
			curDifficulty = 2;
		}
		else if (!(songNameLow=="termination"))
		{
			if (diffText.text == "VERY UNFAIR")
				diffText.text = "UNFAIR";
		}

		if(songNameLow=="power-link")
			{
				diffText.text = "HARDER THAN USUAL";
				curDifficulty = 2;
			}
		else if (!(songNameLow=="power-link"))
		{
			if (diffText.text == "HARDER THAN USUAL")
				diffText.text = "UNFAIR";
		}

		if(songNameLow=="censory-overload")
		{
			diffText.text = "DEMON";
			curDifficulty = 2;
		}
		else if (!(songNameLow=="censory-overload"))
		{
			if (diffText.text == "DEMON")
				diffText.text = "UNFAIR";
		}

		if(songNameLow=="final-destination")
			{
				diffText.text = "GODLY IMPOSSIBLE";
				curDifficulty = 2;
			}
		else if (!(songNameLow=="final-destination"))
		{
			if (diffText.text == "GODLY IMPOSSIBLE")
				diffText.text = "UNFAIR";
		}

		if(songNameLow=="terminate")
			{
				diffText.text = "CRASHERS";
				curDifficulty = 2;
			}
		else if (!(songNameLow=="terminate"))
			{
				if (diffText.text == "CRASHERS")
					diffText.text = "UNFAIR";
			}
	}

	function changeDiff(change:Int = 0)
	{
		var songNameLow = songs[curSelected].songName.toLowerCase();

		if(songNameLow=="termination")
			{
				curDifficulty = 2; //Force it to hard difficulty.
				if(FlxG.save.data.terminationUnlocked)
					diffText.text = "VERY UNFAIR";
				else
					diffText.text = "LOCKED NICE TRY";
				#if !switch
				intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
				#end
				
			}
			else if(songNameLow=="power-link")
				{
					curDifficulty = 2; //Force it to hard difficulty.
					if(FlxG.save.data.terminateWon)
						diffText.text = "HARDER THAN USUAL";
					else
						diffText.text = "LOCKED NICE TRY";
					#if !switch
					intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
					#end
					
				}
			else if(songNameLow=="final-destination")
				{
					curDifficulty = 2; //Force it to hard difficulty.
					if(FlxG.save.data.terminationBeaten)
						diffText.text = "GODLY IMPOSSIBLE";
					else
						diffText.text = "LOCKED NICE TRY";
					#if !switch
					intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
					#end
					
				}
			else if(songNameLow=="cessation")
			{
				curDifficulty = 1; //Force it to normal difficulty.
				if(FlxG.save.data.terminationBeaten)
					diffText.text = "WTF HOW ARE YOU EVEN FUCKING HERE";
				else
					diffText.text = "STOP TRYING TO CHEAT";
				#if !switch
				intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
				#end
			}
			else if(songNameLow=="censory-overload")
			{
				curDifficulty = 2; //Force it to hard difficulty.
				if(FlxG.save.data.terminateWon)
					diffText.text = "DEMON";
				else
					diffText.text = "STOP TRYING TO CHEAT";
				#if !switch
				intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
				#end
			}
			else
			{
				curDifficulty += change;
	
				if (curDifficulty < 0)
					curDifficulty = 2;
				if (curDifficulty > 2)
					curDifficulty = 0;
	
				switch (curDifficulty)
				{
					case 0:
						diffText.text = "EASY";
					case 1:
						diffText.text = 'HARD';
					case 2:
						diffText.text = "UNFAIR";
				}
			}
	
			#if !switch
			intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
			#end		
	}

	function changeSelection(change:Int = 0)
	{
		#if !switch
		// NGio.logEvent('Fresh');
		#end

		// NGio.logEvent('Fresh');
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;
		
		// adjusting the highscore song name to be compatible (changeSelection)
		// would read original scores if we didn't change packages
		var songHighscore = StringTools.replace(songs[curSelected].songName, " ", "-");
		switch (songHighscore) {
			case 'Dad-Battle': songHighscore = 'Dadbattle';
			case 'Philly-Nice': songHighscore = 'Philly';
		}

		#if !switch
		intendedScore = Highscore.getScore(songHighscore, curDifficulty);
		combo = Highscore.getCombo(songHighscore, curDifficulty);
		// lerpScore = 0;
		#end

		#if PRELOAD_ALL
		#if desktop
	//	FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0);
		#end
		#end

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";

	public function new(song:String, week:Int, songCharacter:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
	}
}
