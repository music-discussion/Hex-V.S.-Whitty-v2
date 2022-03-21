package;

import flixel.FlxSprite;

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();

		switch(char)
		{
			case 'trickyMask' | 'tricky':
				loadGraphic(Paths.image('IconGridTricky','clown'), true, 150, 150);

				antialiasing = true;
				animation.add('tricky', [2, 3], 0, false, isPlayer);
				animation.add('trickyMask', [0, 1], 0, false, isPlayer);
			case 'trickyH':
				loadGraphic(Paths.image('hellclwn/hellclownIcon','clown'), true, 150, 150);
				animation.add('trickyH', [0, 1], 0, false, isPlayer);
				y -= 25;
			case 'exTricky':
				loadGraphic(Paths.image('fourth/exTrickyIcons','clown'), true, 150, 150);
				animation.add('exTricky', [0, 1], 0, false, isPlayer);
			case 'robot' | 'robot_404' | 'qt' | 'qt_annoyed' | 'robot_classic' | 'qt-kb' | 'qt_classic' | 'robot_classic_404' | 'qt-meme' | 'robot_404-TERMINATION': // why tf so many characters. i need some chill time.
				loadGraphic(Paths.image('QTiconGrid'), true, 150, 150);

				antialiasing = true;

				animation.add('robot', [24, 25], 0, false, isPlayer); // did
				animation.add('robot_404', [24, 25], 0, false, isPlayer); //Just in case; //did
				animation.add('robot_404-TERMINATION', [24, 25], 0, false, isPlayer); //Just in case;
				animation.add('qt', [26, 27], 0, false, isPlayer); //did
				animation.add('qt_annoyed', [26, 27], 0, false, isPlayer); //did
				animation.add('qt-meme', [26, 27], 0, false, isPlayer); //dude why not
				animation.add('qt-kb', [28, 29], 0, false, isPlayer); //did
				animation.add('qt_classic', [26, 27], 0, false, isPlayer); //did
				animation.add('robot_classic', [24, 25], 0, false, isPlayer); //did
				animation.add('robot_classic_404', [24, 25], 0, false, isPlayer);
			default:
				loadGraphic(Paths.image('iconGrid'), true, 150, 150);

				antialiasing = true;
				animation.add('bf', [0, 1], 0, false, isPlayer);
				animation.add('bf_404', [0, 1], 0, false, isPlayer);
				animation.add('bf-car', [0, 1], 0, false, isPlayer);
				animation.add('bf-christmas', [0, 1], 0, false, isPlayer);
				animation.add('bf-pixel', [21, 21], 0, false, isPlayer);
				animation.add('spooky', [2, 3], 0, false, isPlayer);
				animation.add('pico', [4, 5], 0, false, isPlayer);
				animation.add('mom', [6, 7], 0, false, isPlayer);
				animation.add('mom-car', [6, 7], 0, false, isPlayer);
				animation.add('tankman', [8, 9], 0, false, isPlayer);
				animation.add('face', [10, 11], 0, false, isPlayer);
				animation.add('dad', [12, 13], 0, false, isPlayer);
				animation.add('senpai', [22, 22], 0, false, isPlayer);
				animation.add('senpai-angry', [22, 22], 0, false, isPlayer);
				animation.add('spirit', [23, 23], 0, false, isPlayer);
				animation.add('bf-old', [14, 15], 0, false, isPlayer);
				animation.add('gf', [16], 0, false, isPlayer);
				animation.add('gf-christmas', [16], 0, false, isPlayer);
				animation.add('gf-pixel', [16], 0, false, isPlayer);
				animation.add('parents-christmas', [17, 18], 0, false, isPlayer);
				animation.add('monster', [19, 20], 0, false, isPlayer);
				animation.add('monster-christmas', [19, 20], 0, false, isPlayer);
				animation.add('hex', [24, 25], 0, false, isPlayer);
				animation.add('garcellotired', [26, 27], 0, false, isPlayer);
				animation.add('garcellodead', [28, 29], 0, false, isPlayer);
				animation.add('garcelloghosty', [28, 29], 0, false, isPlayer);

				animation.add('nBob', [0, 1], 0, false, isPlayer);
				animation.add('bosip', [0, 1], 0, false, isPlayer);

				animation.add('matt', [0, 1], 0, false, isPlayer);
				animation.add('garcello', [0, 1], 0, false, isPlayer);
				animation.add('shaggy', [4, 5], 0, false, isPlayer);
				animation.add('hankchar', [0, 1], 0, false, isPlayer);
				animation.add('bfWhitty', [0, 1], 0, false, isPlayer);
				animation.add('garcello', [0, 1], 0, false, isPlayer);
				animation.add('ruv', [0, 1], 0, false, isPlayer);
				animation.add('sky', [0, 1], 0, false, isPlayer);
				animation.add('bob', [0, 1], 0, false, isPlayer);
				animation.add('zardy', [0, 1], 0, false, isPlayer);
				animation.add('tabi', [0, 1], 0, false, isPlayer);
				animation.add('agoti', [0, 1], 0, false, isPlayer);
				animation.add('tordbot', [0, 1], 0, false, isPlayer);

		/*		animation.add('robot', [24, 25], 0, false, isPlayer);
				animation.add('robot_404', [24, 25], 0, false, isPlayer); //Just in case;
				animation.add('robot_404-TERMINATION', [24, 25], 0, false, isPlayer); //Just in case;
				animation.add('qt', [26, 27], 0, false, isPlayer);
				animation.add('qt_annoyed', [26, 27], 0, false, isPlayer);
				animation.add('qt-meme', [26, 27], 0, false, isPlayer);
				animation.add('qt-kb', [28, 29], 0, false, isPlayer);
				animation.add('qt_classic', [26, 27], 0, false, isPlayer);
				animation.add('robot_classic', [24, 25], 0, false, isPlayer);
				animation.add('robot_classic_404', [24, 25], 0, false, isPlayer);
				*/
				animation.play(char);

				//loadGraphic(Paths.image('bobGrid'), true, 150, 150);
	
				//antialiasing = true;
		}
		animation.play(char);
		antialiasing = true;
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
