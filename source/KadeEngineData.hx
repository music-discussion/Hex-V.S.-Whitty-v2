import flixel.input.gamepad.FlxGamepad;
import openfl.Lib;
import flixel.FlxG;

class KadeEngineData
{
	
var data = "{\"name\":null,\"assets\":\"aoy4:pathy24:assets%2Fdata%2Fammo.txty4:sizei17y4:typey4
:TEXTy2:idR1y7:preloadtgoR0y43:assets%2Fdata%2Fcensory-overload%2F0.offsetR2zR3R4R5R7R6tgoR0y61:assets%2Fdata%2Fcensory-overload%2
Fcensory-overload-easy.jsonR2i71248R3R4R5R8R6tgoR0y61:assets%2Fdata%2Fcensory-overload%2Fcensory-overload-hard.jsonR2i76078R3R4R5R9R
6tgoR0y63:assets%2Fdata%2Fcensory-overload%2Fcensory-overload-unfair.jsonR2i99562R3R4R5R10R6tgoR0y63:assets%2Fdata%2Fcensory-overload%2
Fcensory-overloadDialogue.txtR2i229R3R4R5R11R6tgoR0y47:assets%2Fdata%2Fcensory-overload%2Fmodchart.luaR2i10955R3R4R5R12R6tgoR0y33:assets%2F
data%2FcharacterList.txtR2i78R3R4R5R13R6tgoR0y28:assets%2Fdata%2Fcontrols.txtR2i324R3R4R5R14R6tgoR0y30:assets%2Fdata%2FcutMyBalls.txtR2i58R
3R4R5R15R6tgoR0y34:assets%2Fdata%2Fdata-goes-here.txtR2zR3R4R5R16R6tgoR0y38:assets%2Fdata%2Fexpurgation%2F1.offsetR2zR3R4R5R17R6tgoR0y51:ass
ets%2Fdata%2Fexpurgation%2Fexpurgation-easy.jsonR2i63958R3R4R5R18R6tgoR0y51:assets%2Fdata%2Fexpurgation%2Fexpurgation-hard.jsonR2i67280R3R4R5R
19R6tgoR0y53:assets%2Fdata%2Fexpurgation%2Fexpurgation-unfair.jsonR2i95580R3R4R5R20R6tgoR0y46:assets%2Fdata%2Fexpurgation%2Fexpurgation.jsonR2i
63956R3R4R5R21R6tgoR0y42:assets%2Fdata%2Fexpurgation%2Fmodchart.luaR2i57R3R4R5R22R6tgoR0y44:assets%2Fdata%2Ffinal-destination%2F0.offsetR2zR3R4R5R2
3R6tgoR0y63:assets%2Fdata%2Ffinal-destination%2Ffinal-destination-hard.jsonR2i55383R3R4R5R24R6tgoR0y65:assets%2Fdata%2Ffinal-destination%2Ffinal-d
estination-unfair.jsonR2i60343R3R4R5R25R6tgoR0y36:assets%2Fdata%2FfreeplaySonglist.txtR2i31R3R4R5R26R6tgoR0y33:assets%2Fdata%2FgfVersionList.txt
R2i31R3R4R5R27R6tgoR0y47:assets%2Fdata%2Fhellclown%2Fhellclown-easy.jsonR2i62170R3R4R5R28R6tgoR0y47:assets%2Fdata%2Fhellclown%2Fhellclown-hard.json
R2i70256R3R4R5R29R6tgoR0y49:assets%2Fdata%2Fhellclown%2Fhellclown-unfair.jsonR2i74470R3R4R5R30R6tgoR0y63:assets%2Fdata%2Fimprobable-outset%2Fimprob
able-outset-easy.jsonR2i21385R3R4R5R31R6tgoR0y63:assets%2Fdata%2Fimprobable-outset%2Fimprobable-outset-hard.jsonR2i21553R3R4R5R32R6tgoR0y65:assets%2Fdata%2Fimprobable-outset%2Fimprobable-outset-unfair.jsonR2i21932R3R4R5R33R6tgoR0y29:assets%2Fdata%2FintroText.txtR2i1878R3R4R5R34R6tgoR0y43:assets%2Fdata%2Fmadness%2Fmadness-easy.jsonR2i34478R3R4R5R35R6tgoR0y43:assets%2Fdata%2Fmadness%2Fmadness-hard.jsonR2i38434R3R4R5R36R6tgoR0y45:assets%2Fdata%2Fmadness%2Fmadness-unfair.jsonR2i43709R3R4R5R37R6tgoR0y29:assets%2Fdata%2Fmain-view.xmlR2i123R3R4R5R38R6tgoR0y33:assets%2Fdata%2FnoteStyleList.txtR2i12R3R4R5R39R6tgoR0y34:assets%2Fdata%2FoffsetForNoteX.txtR2i11R3R4R5R40R6tgoR0y34:assets%2Fdata%2FoffsetForNoteY.txtR2i15R3R4R5R41R6tgoR0y37:assets%2Fdata%2Fpower-link%2F0.offsetR2zR3R4R5R42R6tgoR0y49:assets%2Fdata%2Fpower-link%2Fpower-link-hard.jsonR2i54021R3R4R5R43R6tgoR0y51:assets%2Fdata%2Fpower-link%2Fpower-link-unfair.jsonR2i53879R3R4R5R44R6tgoR0y33:assets%2Fdata%2FspecialThanks.txtR2i300R3R4R5R45R6tgoR0y29:assets%2Fdata%2FstageList.txtR2i59R3R4R5R46R6tgoR0y36:assets%2Fdata%2Fterminate%2F0.offsetR2zR3R4R5R47R6tgoR0y47:assets%2Fdata%2Fterminate%2Fterminate-easy.jsonR2i32589R3R4R5R48R6tgoR0y47:assets%2Fdata%2Fterminate%2Fterminate-hard.jsonR2i32712R3R4R5R49R6tgoR0y49:assets%2Fdata%2Fterminate%2Fterminate-unfair.jsonR2i32955R3R4R5R50R6tgoR0y49:assets%2Fdata%2Fterminate%2FterminateDialogue.txtR2i337R3R4R5R51R6tgoR0y52:assets%2Fdata%2Fterminate%2FterminateDialogueEND.txtR2i48R3R4R5R52R6tgoR0y61:assets%2Fdata%2Fterminate%2FterminateDialogueEND_original.txtR2i66R3R4R5R53R6tgoR0y38:assets%2Fdata%2Ftermination%2F0.offsetR2zR3R4R5R54R6tgoR0y42:assets%2Fdata%2Ftermination%2Fmodchart.luaR2i7619R3R4R5R55R6tgoR0y48:assets%2Fdata%2Ftermination%2FmodchartBACKUP.luaR2i1143R3R4R5R56R6tgoR0y50:assets%2Fdata%2Ftermination%2FmodchartBACKUPV2.luaR2i8390R3R4R5R57R6tgoR0y51:assets%2Fdata%2Ftermination%2Ftermination-hard.jsonR2i111737R3R4R5R58R6tgoR0y53:assets%2Fdata%2Ftermination%2Ftermination-unfair.jsonR2i155805R3R4R5R59R6tgoR0y30:assets%2Fdata%2FtitleSongs.txtR2i255R3R4R5R60R6tgoR0y39:assets%2Fdata%2FtrickyExSingStrings.txtR2i194R3R4R5R61R6tgoR0y37:assets%2Fdata%2FtrickyMissStrings.txtR2i156R3R4R5R62R6tgoR0y37:assets%2Fdata%2FtrickySingStrings.txtR2i123R3R4R5R63R6tgoR0y35:assets%2Fdata%2Ftutorial%2F0.offsetR2i1R3y6:BINARYR5R64R6tgoR0y39:assets%2Fdata%2Ftutorial%2Fmodchart.luaR2i2977R3R4R5R66R6tgoR0y45:assets%2Fdata%2Ftutorial%2Ftutorial-easy.jsonR2i5739R3R4R5R67R6tgoR0y45:assets%2Fdata%2Ftutorial%2Ftutorial-hard.jsonR2i3448R3R4R5R68R6tgoR0y40:assets%2Fdata%2Ftutorial%2Ftutorial.jsonR2i5739R3R4R5R69R6tgoR0y30:assets%2Fima
2ges%2Falphabet.pngR2i133325R3y5:IMAGER5R70R6tgoR0y30:assets%2Fimages%2Falphabet.xmlR2i42116R3R4R5R72R6tgoR0y38:assets%2Fimages%2Fbonus%2Fatt
ackv6.pngR2i2185533R3R71R5R73R6tgoR0y38:assets%2Fimages%2Fbonus%2Fattackv6.xmlR2i5226R3R4R5R74R6tgoR0y46:assets%2Fimages%2Fbonus%2Fattack_ale
rt_NEW.pngR2i298665R3R71R5R75R6tgoR0y46:assets%2Fimages%2Fbonus%2Fattack_alert_NEW.xmlR2i1401R3R4R5R76R6tgoR0y42:assets%2Fimages%2Fbonus%2Fpincer-
close.pngR2i23060R3R71R5R77R6tgoR0y41:assets%2Fimages%2Fbonus%2Fpincer-open.pngR2i26505R3R71R5R78R6tgoR0y47:assets%2Fimages%2Fbonus%2Fsawkillanimat
ion2.pngR2i734112R3R71R5R79R6tgoR0y47:assets%2Fimages%2Fbonus%2Fsawkillanimation2.xmlR2i3385R3R4R5R80R6tgoR0y63:assets%2Fimages%2Fbonus%2FThis%20is
%20here%20for%20Tutorial.txtR2i766R3R4R5R81R6tgoR0y45:assets%2Fimages%2Fcampaign_menu_UI_assets.pngR2i27171R3R71R5R82R6tgoR0y45:assets%2Fimages%2Fc
ampaign_menu_UI_assets.xmlR2i1893R3R4R5R83R6tgoR0y49:assets%2Fimages%2Fcampaign_menu_UI_characters.pngR2i2285826R3R71R5R84R6tgoR0y49:assets%2Fimages%2Fcampaign_menu_UI_characters.xmlR2i22475R3R4R5R85R6tgoR0y61:assets%2Fimages%2Fcharacters%2FLeft%2FAlt_Agoti_Sprites_B.pngR2i4322364R3R71R5R86R6tgoR0y61:assets%2Fimages%2Fcharacters%2FLeft%2FAlt_Agoti_Sprites_B.xmlR2i6575R3R4R5R87R6tgoR0y56:assets%2Fimages%2Fcharacters%2FLeft%2Fhellbob_assets.pngR2i515190R3R71R5R88R6tgoR0y56:assets%2Fimages%2Fcharacters%2FLeft%2Fhellbob_assets.xmlR2i7359R3R4R5R89R6tgoR0y49:assets%2Fimages%2Fcharacters%2FLeft%2FMadTabi.pngR2i4867855R3R71R5R90R6tgoR0y49:assets%2Fimages%2Fcharacters%2FLeft%2FMadTabi.xmlR2i6923R3R4R5R91R6tgoR0y55:assets%2Fimages%2Fcharacters%2FLeft%2FSenpai_Spirit.pngR2i3086438R3R71R5R92R6tgoR0y55:assets%2Fimages%2Fcharacters%2FLeft%2FSenpai_Spirit.xmlR2i6531R3R4R5R93R6tgoR0y56:assets%2Fimages%2Fcharacters%2FLeft%2Fsky_mad_assets.pngR2i926139R3R71R5R94R6tgoR0y56:assets%2Fimages%2Fcharacters%2FLeft%2Fsky_mad_assets.xmlR2i6612R3R4R5R95R6tgoR0y56:assets%2Fimages%2Fcharacters%2FLeft%2Ftordbot_assets.pngR2i5382572R3R71R5R96R6tgoR0y56:assets%2Fimages%2Fcharacters%2FLeft%2Ftordbot_assets.xmlR2i2728R3R4R5R97R6tgoR0y47:



assets%2Fimages%2Fcharacters%2FLeft%2FZardy.pngR2i1683174R3R71R5R98R6tgoR0y47:assets%2Fimages%2Fcharacters%2FLeft%2FZardy.xmlR2i5246R3R4R5R99R6tgoR0y54:assets%2Fimages%2Fcharacters%2FRight%2FBF_post_exp.pngR2i6075824R3R71R5R100R6tgoR0y54:assets%2Fimages%2Fcharacters%2FRight%2FBF_post_exp.xmlR2i71496R3R4R5R101R6tgoR0y62:assets%2Fimages%2Fcharacters%2FRight%2Fgarcellodead_assets.pngR2i4212233R3R71R5R102R6tgoR0y62:assets%2Fimages%2Fcharacters%2FRight%2Fgarcellodead_assets.xmlR2i12061R3R4R5R103R6tgoR0y52:assets%2Fimages%2Fcharacters%2FRight%2FHex_Virus.pngR2i3776075R3R71R5R104R6tgoR0y52:assets%2Fimages%2Fcharacters%2FRight%2FHex_Virus.xmlR2i8510R3R4R5R105R6tgoR0y54:assets%2Fimages%2Fcharacters%2FRight%2Fmatt_assets.pngR2i384034R3R71R5R106R6tgoR0y54:assets%2Fimages%2Fcharacters%2FRight%2Fmatt_assets.xmlR2i9052R3R4R5R107R6tgoR0y59:assets%2Fimages%2Fcharacters%2FRight%2FPico_FNF_assetss.pngR2i1750438R3R71R5R108R6tgoR0y59:assets%2Fimages%2Fcharacters%2FRight%2FPico_FNF_assetss.xmlR2i24093R3R4R5R109R6tgoR0y50:assets%2Fimages%2Fcharacters%2FRight%2Fpshaggy.pngR2i2140362R3R71R5R110R6tgoR0y50:assets%2Fimages%2Fcharacters%2FRight%2Fpshaggy.xmlR2i16817R3R4R5R111R6tgoR0y52:assets%2Fimages%2Fcharacters%2FRight%2Fruv_sheet.pngR2i4483996R3R71R5R112R6tgoR0y52:assets%2Fimages%2Fcharacters%2FRight%2Fruv_sheet.xmlR2i12980R3R4R5R113R6tgoR0y53:assets%2Fimages%2Fcharacters%2FRight%2FTrickyMask.pngR2i4930425R3R71R5R114R6tgoR0y53:assets%2Fimages%2Fcharacters%2FRight%2FTrickyMask.xmlR2i8043R3R4R5R115R6tgoR0y54:assets%2Fimages%2Fcharacters%2FRight%2FWhittyCrazy.pngR2i8266522R3R71R5R116R6tgoR0y54:assets%2Fimages%2Fcharacters%2FRight%2FWhittyCrazy.xmlR2i18254R3R4R5R117R6tgoR0y51:assets%2Fimages%2Fcharacters%2Fthegfs%2Fcarolbg.pngR2i38891R3R71R5R118R6tgoR0y59:assets%2Fimages%2Fcharacters%2Fthegfs%2FCarol_GF_assets.pngR2i7171798R3R71R5R119R6tgoR0y61:assets%2Fimages%2Fcharacters%2Fthegfs%2FDestroyed_boombox.pngR2i78368R3R71R5R120R6tgoR0y60:assets%2Fimages%2Fcharacters%2Fthegfs%2FmonsterChristmas.pngR2i1107462R3R71R5R121R6tgoR0y60:assets%2Fimages%2Fcharacters%2Fthegfs%2FmonsterChristmas.xmlR2i14973R3R4R5R122R6tgoR0y61:assets%2Fimages%2Fcharacters%2Fthegfs%2Fobeebob_and_scoob.pngR2i46883R3R71R5R123R6tgoR0y62:assets%2Fimages%2Fcharacters%2Fthegfs%2Fopheebop_and_scoob.pngR2i46883R3R71R5R124R6tgoR0y60:assets%2Fimages%2Fcharacters%2Fthegfs%2FPostExpGF_Assets.pngR2i668495R3R71R5R125R6tgoR0y60:assets%2Fimages%2Fcharacters%2Fthegfs%2FPostExpGF_Assets.xmlR2i2540R3R4R5R126R6tgoR0y50:assets%2Fimages%2Fcharacters%2Fthegfs%2Fscooby.pngR2i1867262R3R71R5R127R6tgoR0y50:assets%2Fimages%2Fcharacters%2Fthegfs%2Fscooby.xmlR2i22578R3R4R5R128R6tgoR0y50:assets%2Fimages%2Fcharacters%2Fthegfs%2Fshaggy.pngR2i4259348R3R71R5R129R6tgoR0y50:assets%2Fimages%2Fcharacters%2Fthegfs%2Fshaggy.xmlR2i59819R3R4R5R130R6tgoR0y54:assets%2Fimages%2Fcharacters%2Fthegfs%2Ftheseknees.pngR2i2468236R3R71R5R131R6tgoR0y54:assets%2Fimages%2Fcharacters%2Fthegfs%2Ftheseknees.xmlR2i1130R3R4R5R132R6tgoR0y42:assets%2Fimages%2FFNF_main_menu_assets.pngR2i281298R3R71R5R133R6tgoR0y42:assets%2Fimages%2FFNF_main_menu_assets.xmlR2i4755R3R4R5R134R6tgoR0y34:assets%2Fimages%2FgfDanceTitle.pngR2i1221436R3R71R5R135R6tgoR0y34:assets%2Fimages%2FgfDanceTitle.xmlR2i4259R3R4R5R136R6tgoR0y30:assets%2Fimages%2FiconGrid.pngR2i285598R3R71R5R137R6tgoR0y36:assets%2Fimages%2FKadeEngineLogo.pngR2i259663R3R71R5R138R6tgoR0y42:assets%2Fimages%2FKadeEngineLogoBumpin.pngR2i1131603R3R71R5R139R6tgoR0y42:assets%2Fimages%2FKadeEngineLogoBumpin.xmlR2i2187R3R4R5R140R6tgoR0y39:assets%2Fimages%2FKadeEngineLogoOld.pngR2i118097R3R71R5R141R6tgoR0y26:assets%2Fimages%2Flogo.pngR2i86924R3R71R5R142R6tgoR0y32:assets%2Fimages%2FlogoBumpin.pngR2i592724R3R71R5R143R6tgoR0y32:assets%2Fimages%2FlogoBumpin.xmlR2i2177R3R4R5R144R6tgoR0y28:assets%2Fimages%2FmenuBG.pngR2i620342R3R71R5R145R6tgoR0y32:assets%2Fimages%2FmenuBGBlue.pngR2i614586R3R71R5R146R6tgoR0y35:assets%2Fimages%2FmenuBGMagenta.pngR2i553468R3R71R5R147R6tgoR0y31:assets%2Fimages%2FmenuDesat.pngR2i357911R3R71R5R148R6tgoR0y37:assets%2Fimages%2Fnewgrounds_logo.pngR2i57747R3R71R5R149R6tgoR0y26:assets%2Fimages%2Fnum0.pngR2i3738R3R71R5R150R6tgoR0y26:assets%2Fimages%2Fnum1.pngR2i3390R3R71R5R151R6tgoR0y26:assets%2Fimages%2Fnum2.pngR2i3990R3R71R5R152R6tgoR0y26:assets%2Fimages%2Fnum3.pngR2i4022R3R71R5R153R6tgoR0y26:assets%2Fimages%2Fnum4.pngR2i3989R3R71R5R154R6tgoR0y26:assets%2Fimages%2Fnum5.pngR2i4113R3R71R5R155R6tgoR0y26:assets%2Fimages%2Fnum6.pngR2i4181R3R71R5R156R6tgoR0y26:assets%2Fimages%2Fnum7.pngR2i3692R3R71R5R157R6tgoR0y26:assets%2Fimages%2Fnum8.pngR2i3914R3R71R5R158R6tgoR0y26:assets%2Fimages%2Fnum9.pngR2i3687R3R71R5R159R6tgoR0y32:assets%2Fimages%2FQTiconGrid.pngR2i244659R3R71R5R160R6tgoR0y29:assets%2Fimages%2Fshadows.pngR2i137397R3R71R5R161R6tgoR0y39:assets%2Fimages%2Fstorymenu%2Fweek0.pngR2i7056R3R71R5R162R6tgoR0y39:assets%2Fimages%2Fstorymenu%2Fweek1.pngR2i6261R3R71R5R163R6tgoR0y39:assets%2Fimages%2Fstorymenu%2Fweek2.pngR2i6517R3R71R5R164R6tgoR0y39:assets%2Fimages%2Fstorymenu%2Fweek3.pngR2i7148R3R71R5R165R6tgoR0y39:assets%2Fimages%2Fstorymenu%2Fweek4.pngR2i6262R3R71R5R166R6tgoR0y39:assets%2Fimages%2Fstorymenu%2Fweek5.pngR2i6440R3R71R5R167R6tgoR0y39:assets%2Fimages%2Fstorymenu%2Fweek6.pngR2i8345R3R71R5R168R6tgoR0y32:assets%2Fimages%2FtitleEnter.pngR2i1449202R3R71R5R169R6tgoR0y32:assets%2Fimages%2FtitleEnter.xmlR2i4875R3R4R5R170R6tgoR0y58:assets%2Fimages%2Fweeb%2FdialogShit%2FdialogueBox-evil.pngR2i1425R3R71R5R171R6tgoR0y58:assets%2Fimages%2Fweeb%2FdialogShit%2FdialogueBox-evil.xmlR2i1385R3R4R5R1

72R6tgoR0y59:assets%2Fimages%2Fweeb%2FdialogShit%2FdialogueBox-pixel.pngR2i7200R3R71R5R173R6tgoR0y59:assets%2Fimages%2Fweeb%2FdialogShit%2FdialogueBox-pixel.xmlR2i680R3R4R5R174R6tgoR0y63:assets%2Fimages%2Fweeb%2FdialogShit%2FdialogueBox-senpaiMad.pngR2i26689R3R71R5R175R6tgoR0y63:assets%2Fimages%2Fweeb%2FdialogShit%2FdialogueBox-senpaiMad.xmlR2i1050R3R4R5R176R6tgoR0y54:assets%2Fimages%2Fweeb%2FdialogShit%2Fhand_textbox.pngR2i260R3R71R5R177R6tgoR0y51:assets%2Fimages%2Fweeb%2FpixelUI%2Fhand_textbox.pngR2i260R3R71R5R178R6tgoR0y40:assets%2Fimages%2Fweeb%2FsenpaiCrazy.pngR2i14142R3R71R5R179R6tgoR0y40:assets%2Fimages%2Fweeb%2FsenpaiCrazy.xmlR2i19805R3R4R5R180R6tgoR2i2309657R3y5:MUSICR5y31:assets%2Fmusic%2FfreakyMenu.mp3y9:pathGroupaR182hR6tgoR2i17762R3R181R5y32:assets%2Fsounds%2FcancelMenu.mp3R183aR184hR6tgoR2i91950R3R181R5y33:assets%2Fsounds%2FconfirmMenu.mp3R183aR185hR6tgoR2i17762R3R181R5y32:assets%2Fsounds%2FscrollMenu.mp3R183aR186hR6tgoR0y46:assets%2Fvideos%2FdaWeirdVid%2FdontDelete.webmR2i10965R3R65R5R187R6tgoR0y80:assets%2Fvideos%2FDO%20NOT%20DELETE%20OR%20GAME%20WILL%20CRASH%2FdontDelete.webmR2i10965R3R65R5R188R6tgoR0y45:assets%2Fvideos%2FHankFuckingShootsTricky.txtR2i3R3R4R5R189R6tgoR0y46:assets%2Fvideos%2FHankFuckingShootsTricky.webmR2i7825863R3R65R5R190R6tgoR0y40:assets%2Fvideos%2FHELLCLOWN_ENGADGED.txtR2i3R3R4R5R191R6tgoR0y41:assets%2Fvideos%2FHELLCLOWN_ENGADGED.webmR2i11736317R3R65R5R192R6tgoR0y34:assets%2Fvideos%2FTricksterMan.txtR2i4R3R4R5R193R6tgoR0y29:assets%2Fvideos%2FTestVid.mp4R2i2909007R3R65R5R194R6tgoR0y40:assets%2Fvideos%2Fvideos%20go%20here.txtR2zR3R4R5R195R6tgoR0y48:mods%2FintroMod%2F_append%2Fdata%2FintroText.txtR2i20R3R4R5R196goR0y18:mods%2FmodList.txtR2i8R3R4R5R197goR0y17:mods%2Freadme.txtR2i90R3R4R5R198goR0y21:do%20NOT%20readme.txtR2i4326R3R4R5R199R6tgoR0y11:LICENSE.txtR2i11407R3R4R5R200R6tgoR0y34:assets%2Ffonts%2Ffonts-go-here.txtR2zR3R4R5R201R6tgoR2i14656R3y4:FONTy9:classNamey31:__ASSET__assets_fonts_pixel_otfR5y26:assets%2Ffonts%2Fpixel.otfR6tgoR2i75864R3R202R203y29:__ASSET__assets_fonts_vcr_ttfR5y24:assets%2Ffonts%2Fvcr.ttfR6tgoR2i2114R3R181R5y26:flixel%2Fsounds%2Fbeep.mp3R183aR208y26:flixel%2Fsounds%2Fbeep.ogghR6tgoR2i39706R3R181R5y28:flixel%2Fsounds%2Fflixel.mp3R183aR210y28:flixel%2Fsounds%2Fflixel.ogghR6tgoR2i5794R3y5:SOUNDR5R209R183aR208R209hgoR2i33629R3R212R5R211R183aR210R211hgoR2i15744R3R202R203y35:__ASSET__flixel_fonts_nokiafc22_ttfR5y30:flixel%2Ffonts%2Fnokiafc22.ttfR6tgoR2i29724R3R202R203y36:__ASSET__flixel_fonts_monsterrat_ttfR5y31:flixel%2Ffonts%2Fmonsterrat.ttfR6tgoR0y33:flixel%2Fimages%2Fui%2Fbutton.pngR2i519R3R71R5R217R6tgoR0y36:flixel%2Fimages%2Flogo%2Fdefault.pngR2i3280R3R71R5R218R6tgoR0y34:flixel%2Fflixel-ui%2Fimg%2Fbox.pngR2i912R3R71R5R219R6tgoR0y37:flixel%2Fflixel-ui%2Fimg%2Fbutton.pngR2i433R3R71R5R220R6tgoR0y48:flixel%2Fflixel-ui%2Fimg%2Fbutton_arrow_down.pngR2i446R3R71R5R221R6tgoR0y48:flixel%2Fflixel-ui%2Fimg%2Fbutton_arrow_left.pngR2i459R3R71R5R222R6tgoR0y49:flixel%2Fflixel-ui%2Fimg%2Fbutton_arrow_right.pngR2i511R3R71R5R223R6tgoR0y46:flixel%2Fflixel-ui%2Fimg%2Fbutton_arrow_up.pngR2i493R3R71R5R224R6tgoR0y42:flixel%2Fflixel-ui%2Fimg%2Fbutton_thin.pngR2i247R3R71R5R225R6tgoR0y44:flixel%2Fflixel-ui%2Fimg%2Fbutton_toggle.pngR2i534R3R71R5R226R6tgoR0y40:flixel%2Fflixel-ui%2Fimg%2Fcheck_box.pngR2i922R3R71R5R227R6tgoR0y41:flixel%2Fflixel-ui%2Fimg%2Fcheck_mark.pngR2i946R3R71R5R228R6tgoR0y37:flixel%2Fflixel-ui%2Fimg%2Fchrome.pngR2i253R3R71R5R229R6tgoR0y42:flixel%2Fflixel-ui%2Fimg%2Fchrome_flat.pngR2i212R3R71R5R230R6tgoR0y43:flixel%2Fflixel-ui%2Fimg%2Fchrome_inset.pngR2i192R3R71R5R231R6tgoR0y43:flixel%2Fflixel-ui%2Fimg%2Fchrome_light.pngR2i214R3R71R5R232R6tgoR0y44:flixel%2Fflixel-ui%2Fimg%2Fdropdown_mark.pngR2i156R3R71R5R233R6tgoR0y41:flixel%2Fflixel-ui%2Fimg%2Ffinger_big.pngR2i1724R3R71R5R234R6tgoR0y43:flixel%2Fflixel-ui%2Fimg%2Ffinger_small.pngR2i294R3R71R5R235R6tgoR0y38:flixel%2Fflixel-ui%2Fimg%2Fhilight.pngR2i129R3R71R5R236R6tgoR0y36:flixel%2Fflixel-ui%2Fimg%2Finvis.pngR2i128R3R71R5R237R6tgoR0y41:flixel%2Fflixel-ui%2Fimg%2Fminus_mark.pngR2i136R3R71R5R238R6tgoR0y40:flixel%2Fflixel-ui%2Fimg%2Fplus_mark.pngR2i147R3R71R5R239R6tgoR0y36:flixel%2Fflixel-ui%2Fimg%2Fradio.pngR2i191R3R71R5R240R6tgoR0y40:flixel%2Fflixel-ui%2Fimg%2Fradio_dot.pngR2i153R3R71R5R241R6tgoR0y37:flixel%2Fflixel-ui%2Fimg%2Fswatch.pngR2i185R3R71R5R242R6tgoR0y34:flixel%2Fflixel-ui%2Fimg%2Ftab.pngR2i201R3R71R5R243R6tgoR0y39:flixel%2Fflixel-ui%2Fimg%2Ftab_back.pngR2i210R3R71R5R244R6tgoR0y44:flixel%2Fflixel-ui%2Fimg%2Ftooltip_arrow.pngR2i18509R3R71R5R245R6tgoR0y39:flixel%2Fflixel-ui%2Fxml%2Fdefaults.xmlR2i1263R3R4R5R246R6tgoR0y53:flixel%2Fflixel-ui%2Fxml%2Fdefault_loading_screen.xmlR2i1953R3R4R5R247R6tgoR0y44:flixel%2Fflixel-ui%2Fxml%2Fdefault_popup.xmlR2i1848R3R4R5R248R6tgh\",\"rootPath\":null,\"version\":2,\"libraryArgs\":[],\"libraryType\":null}"
;

    public static function initSave()
    {
        if (FlxG.save.data.newInput == null)
			FlxG.save.data.newInput = true;

		if (FlxG.save.data.downscroll == null)
			FlxG.save.data.downscroll = false;

		if (FlxG.save.data.antialiasing == null)
			FlxG.save.data.antialiasing = true;

		if (FlxG.save.data.missSounds == null)
			FlxG.save.data.missSounds = true;

		if (FlxG.save.data.dfjk == null)
			FlxG.save.data.dfjk = false;
			
		if (FlxG.save.data.accuracyDisplay == null)
			FlxG.save.data.accuracyDisplay = true;

		if (FlxG.save.data.offset == null)
			FlxG.save.data.offset = 0;

		if (FlxG.save.data.songPosition == null)
			FlxG.save.data.songPosition = false;

		if (FlxG.save.data.fps == null)
			FlxG.save.data.fps = false;

		if (FlxG.save.data.changedHit == null)
		{
			FlxG.save.data.changedHitX = -1;
			FlxG.save.data.changedHitY = -1;
			FlxG.save.data.changedHit = false;
		}

		if (FlxG.save.data.fpsRain == null)
			FlxG.save.data.fpsRain = false;

		if (FlxG.save.data.fpsCap == null)
			FlxG.save.data.fpsCap = 120;

		if (FlxG.save.data.fpsCap > 285 || FlxG.save.data.fpsCap < 60)
			FlxG.save.data.fpsCap = 120; // baby proof so you can't hard lock ur copy of kade engine
		
		if (FlxG.save.data.scrollSpeed == null)
			FlxG.save.data.scrollSpeed = 1;

		if (FlxG.save.data.npsDisplay == null)
			FlxG.save.data.npsDisplay = false;

		if (FlxG.save.data.frames == null)
			FlxG.save.data.frames = 10;

		if (FlxG.save.data.accuracyMod == null)
			FlxG.save.data.accuracyMod = 1;

		if (FlxG.save.data.watermark == null)
			FlxG.save.data.watermark = true;

		if (FlxG.save.data.ghost == null)
			FlxG.save.data.ghost = true;

		if (FlxG.save.data.distractions == null)
			FlxG.save.data.distractions = true;

		if (FlxG.save.data.flashing == null)
			FlxG.save.data.flashing = true;

		if (FlxG.save.data.resetButton == null)
			FlxG.save.data.resetButton = false;

		if (FlxG.save.data.InstantRespawn == null)
			FlxG.save.data.InstantRespawn = false;
		
		if (FlxG.save.data.botplay == null)
			FlxG.save.data.botplay = false;

		if (FlxG.save.data.noBotplay == null)
			FlxG.save.data.noBotplay = false;

		if (FlxG.save.data.cpuStrums == null)
			FlxG.save.data.cpuStrums = false;
	#if desktop
	FlxG.save.data.cpuStrums = true;
	#end

		if (FlxG.save.data.strumline == null)
			FlxG.save.data.strumline = false;
		
		if (FlxG.save.data.customStrumLine == null)
			FlxG.save.data.customStrumLine = 0;

		if (FlxG.save.data.camzoom == null)
			FlxG.save.data.camzoom = true;

		if (FlxG.save.data.scoreScreen == null)
			FlxG.save.data.scoreScreen = true;

		if (FlxG.save.data.inputShow == null)
			FlxG.save.data.inputShow = false;

		if (FlxG.save.data.optimize == null)
			FlxG.save.data.optimize = false;
		
		if (FlxG.save.data.cacheImages == null)
			FlxG.save.data.cacheImages = false;

		if (FlxG.save.data.oldtimings == null)
			FlxG.save.data.oldtimings = false;

		if (FlxG.save.data.gracetmr == null)
			FlxG.save.data.gracetmr = true;

		if (FlxG.save.data.noteSplash == null)
			FlxG.save.data.noteSplash = true;

		if (FlxG.save.data.zoom == null)
			FlxG.save.data.zoom = 1;

		if (FlxG.save.data.noteColor == null)
			FlxG.save.data.noteColor = "darkred";

		if (FlxG.save.data.gthc == null)
			FlxG.save.data.gthc = false;

		if (FlxG.save.data.gthm == null)
			FlxG.save.data.gthm = false;

		if (FlxG.save.data.randomNotes == null)
			FlxG.save.data.randomNotes = false;

		if (FlxG.save.data.randomSection == null)
			FlxG.save.data.randomSection = true;

		if (FlxG.save.data.mania == null)
			FlxG.save.data.mania = 0;

		if (FlxG.save.data.randomMania == null)
			FlxG.save.data.randomMania = 0;

		if (FlxG.save.data.flip == null)
			FlxG.save.data.flip = false;

		if (FlxG.save.data.bothSide == null)
			FlxG.save.data.bothSide = false;

		if (FlxG.save.data.randomNoteTypes == null)
			FlxG.save.data.randomNoteTypes = 0;

		if (FlxG.save.data.beatenHard == null)
			FlxG.save.data.beatenHard = false;
		
		if (FlxG.save.data.beaten == null)
			FlxG.save.data.beaten = false;

		if (FlxG.save.data.beatEx == null)
			FlxG.save.data.beatEx = false;

		if (FlxG.save.data.won == null)
			FlxG.save.data.won = false;

		if (FlxG.save.data.cheats == null)
			FlxG.save.data.cheats = false;

		if (FlxG.save.data.placeHolder == null)
			FlxG.save.data.placeHolder = false;

		if (FlxG.save.data.didError == null)
			FlxG.save.data.didError = false;

		if (FlxG.save.data.diffStory == null)
			FlxG.save.data.diffStory = false;

		if (FlxG.save.data.terminateWon == null)
			FlxG.save.data.terminateWon = false;

		if (FlxG.save.data.didCensory == null)
			FlxG.save.data.didCensory = false;

		if (FlxG.save.data.cheatsV2 == null)
			FlxG.save.data.cheatsV2 = false;

		if (FlxG.save.data.terminationBeaten == null)
			FlxG.save.data.terminationBeaten = false;

		if (FlxG.save.data.isEligible == null)
			FlxG.save.data.isEligible = false;

		if (FlxG.save.data.terminationUnlocked == null)
			FlxG.save.data.terminationUnlocked = false;

		if (FlxG.save.data.powerWon == null)
			FlxG.save.data.powerWon = false;

		if (FlxG.save.data.no == null)
			FlxG.save.data.no = false;

		if (FlxG.save.data.noSaw == null)
			FlxG.save.data.noSaw == false;

		if (FlxG.save.data.customSongs == null)
			FlxG.save.data.customSongs == false;
		
		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;
		
		KeyBinds.gamepad = gamepad != null;

		Conductor.recalculateTimings();
		PlayerSettings.player1.controls.loadKeyBinds();
		KeyBinds.keyCheck();

		Main.watermarks = FlxG.save.data.watermark;

		(cast (Lib.current.getChildAt(0), Main)).setFPSCap(FlxG.save.data.fpsCap);
	}
}

/*
var data = "{\"name\":null,\"assets\":\"aoy4:pathy24:assets%2Fdata%2Fammo.txty4:sizei17y4:typey4:TEXTy2:idR1y7:preloadtgoR0y43:assets%2Fdata%2Fcensory-overload%2F0.offsetR2zR3R4R5R7R6tgoR0y61:assets%2Fdata%2Fcensory-overload%2Fcensory-overload-easy.jsonR2i71248R3R4R5R8R6tgoR0y61:assets%2Fdata%2Fcensory-overload%2Fcensory-overload-hard.jsonR2i76078R3R4R5R9R6tgoR0y63:assets%2Fdata%2Fcensory-overload%2Fcensory-overload-unfair.jsonR2i99562R3R4R5R10R6tgoR0y63:assets%2Fdata%2Fcensory-overload%2Fcensory-overloadDialogue.txtR2i229R3R4R5R11R6tgoR0y47:assets%2Fdata%2Fcensory-overload%2Fmodchart.luaR2i10955R3R4R5R12R6tgoR0y33:assets%2Fdata%2FcharacterList.txtR2i78R3R4R5R13R6tgoR0y28:assets%2Fdata%2Fcontrols.txtR2i324R3R4R5R14R6tgoR0y30:assets%2Fdata%2FcutMyBalls.txtR2i58R3R4R5R15R6tgoR0y34:assets%2Fdata%2Fdata-goes-here.txtR2zR3R4R5R16R6tgoR0y38:assets%2Fdata%2Fexpurgation%2F1.offsetR2zR3R4R5R17R6tgoR0y51:assets%2Fdata%2Fexpurgation%2Fexpurgation-easy.jsonR2i63958R3R4R5R18R6tgoR0y51:assets%2Fdata%2Fexpurgation%2Fexpurgation-hard.jsonR2i67280R3R4R5R19R6tgoR0y53:assets%2Fdata%2Fexpurgation%2Fexpurgation-unfair.jsonR2i95580R3R4R5R20R6tgoR0y46:assets%2Fdata%2Fexpurgation%2Fexpurgation.jsonR2i63956R3R4R5R21R6tgoR0y42:assets%2Fdata%2Fexpurgation%2Fmodchart.luaR2i57R3R4R5R22R6tgoR0y44:assets%2Fdata%2Ffinal-destination%2F0.offsetR2zR3R4R5R23R6tgoR0y63:assets%2Fdata%2Ffinal-destination%2Ffinal-destination-hard.jsonR2i55383R3R4R5R24R6tgoR0y65:assets%2Fdata%2Ffinal-destination%2Ffinal-destination-unfair.jsonR2i60343R3R4R5R25R6tgoR0y36:assets%2Fdata%2FfreeplaySonglist.txtR2i31R3R4R5R26R6tgoR0y33:assets%2Fdata%2FgfVersionList.txtR2i31R3R4R5R27R6tgoR0y47:assets%2Fdata%2Fhellclown%2Fhellclown-easy.jsonR2i62170R3R4R5R28R6tgoR0y47:assets%2Fdata%2Fhellclown%2Fhellclown-hard.jsonR2i70256R3R4R5R29R6tgoR0y49:assets%2Fdata%2Fhellclown%2Fhellclown-unfair.jsonR2i74470R3R4R5R30R6tgoR0y63:assets%2Fdata%2Fimprobable-outset%2Fimprobable-outset-easy.jsonR2i21385R3R4R5R31R6tgoR0y63:assets%2Fdata%2Fimprobable-outset%2Fimprobable-outset-hard.jsonR2i21553R3R4R5R32R6tgoR0y65:assets%2Fdata%2Fimprobable-outset%2Fimprobable-outset-unfair.jsonR2i21932R3R4R5R33R6tgoR0y29:assets%2Fdata%2FintroText.txtR2i1878R3R4R5R34R6tgoR0y43:assets%2Fdata%2Fmadness%2Fmadness-easy.jsonR2i34478R3R4R5R35R6tgoR0y43:assets%2Fdata%2Fmadness%2Fmadness-hard.jsonR2i38434R3R4R5R36R6tgoR0y45:assets%2Fdata%2Fmadness%2Fmadness-unfair.jsonR2i43709R3R4R5R37R6tgoR0y29:assets%2Fdata%2Fmain-view.xmlR2i123R3R4R5R38R6tgoR0y33:assets%2Fdata%2FnoteStyleList.txtR2i12R3R4R5R39R6tgoR0y34:assets%2Fdata%2FoffsetForNoteX.txtR2i11R3R4R5R40R6tgoR0y34:assets%2Fdata%2FoffsetForNoteY.txtR2i15R3R4R5R41R6tgoR0y37:assets%2Fdata%2Fpower-link%2F0.offsetR2zR3R4R5R42R6tgoR0y49:assets%2Fdata%2Fpower-link%2Fpower-link-hard.jsonR2i54021R3R4R5R43R6tgoR0y51:assets%2Fdata%2Fpower-link%2Fpower-link-unfair.jsonR2i53879R3R4R5R44R6tgoR0y33:assets%2Fdata%2FspecialThanks.txtR2i300R3R4R5R45R6tgoR0y29:assets%2Fdata%2FstageList.txtR2i59R3R4R5R46R6tgoR0y36:assets%2Fdata%2Fterminate%2F0.offsetR2zR3R4R5R47R6tgoR0y47:assets%2Fdata%2Fterminate%2Fterminate-easy.jsonR2i32589R3R4R5R48R6tgoR0y47:assets%2Fdata%2Fterminate%2Fterminate-hard.jsonR2i32712R3R4R5R49R6tgoR0y49:assets%2Fdata%2Fterminate%2Fterminate-unfair.jsonR2i32955R3R4R5R50R6tgoR0y49:assets%2Fdata%2Fterminate%2FterminateDialogue.txtR2i337R3R4R5R51R6tgoR0y52:assets%2Fdata%2Fterminate%2FterminateDialogueEND.txtR2i48R3R4R5R52R6tgoR0y61:assets%2Fdata%2Fterminate%2FterminateDialogueEND_original.txtR2i66R3R4R5R53R6tgoR0y38:assets%2Fdata%2Ftermination%2F0.offsetR2zR3R4R5R54R6tgoR0y42:assets%2Fdata%2Ftermination%2Fmodchart.luaR2i7619R3R4R5R55R6tgoR0y48:assets%2Fdata%2Ftermination%2FmodchartBACKUP.luaR2i1143R3R4R5R56R6tgoR0y50:assets%2Fdata%2Ftermination%2FmodchartBACKUPV2.luaR2i8390R3R4R5R57R6tgoR0y51:assets%2Fdata%2Ftermination%2Ftermination-hard.jsonR2i111737R3R4R5R58R6tgoR0y53:assets%2Fdata%2Ftermination%2Ftermination-unfair.jsonR2i155805R3R4R5R59R6tgoR0y30:assets%2Fdata%2FtitleSongs.txtR2i255R3R4R5R60R6tgoR0y39:assets%2Fdata%2FtrickyExSingStrings.txtR2i194R3R4R5R61R6tgoR0y37:assets%2Fdata%2FtrickyMissStrings.txtR2i156R3R4R5R62R6tgoR0y37:assets%2Fdata%2FtrickySingStrings.txtR2i123R3R4R5R63R6tgoR0y35:assets%2Fdata%2Ftutorial%2F0.offsetR2i1R3y6:BINARYR5R64R6tgoR0y39:assets%2Fdata%2Ftutorial%2Fmodchart.luaR2i2977R3R4R5R66R6tgoR0y45:assets%2Fdata%2Ftutorial%2Ftutorial-easy.jsonR2i5739R3R4R5R67R6tgoR0y45:assets%2Fdata%2Ftutorial%2Ftutorial-hard.jsonR2i3448R3R4R5R68R6tgoR0y40:assets%2Fdata%2Ftutorial%2Ftutorial.jsonR2i5739R3R4R5R69R6tgoR0y30:assets%2Fima2ges%2Falphabet.pngR2i133325R3y5:IMAGER5R70R6tgoR0y30:assets%2Fimages%2Falphabet.xmlR2i42116R3R4R5R72R6tgoR0y38:assets%2Fimages%2Fbonus%2Fattackv6.pngR2i2185533R3R71R5R73R6tgoR0y38:assets%2Fimages%2Fbonus%2Fattackv6.xmlR2i5226R3R4R5R74R6tgoR0y46:assets%2Fimages%2Fbonus%2Fattack_alert_NEW.pngR2i298665R3R71R5R75R6tgoR0y46:assets%2Fimages%2Fbonus%2Fattack_alert_NEW.xmlR2i1401R3R4R5R76R6tgoR0y42:assets%2Fimages%2Fbonus%2Fpincer-close.pngR2i23060R3R71R5R77R6tgoR0y41:assets%2Fimages%2Fbonus%2Fpincer-open.pngR2i26505R3R71R5R78R6tgoR0y47:assets%2Fimages%2Fbonus%2Fsawkillanimation2.pngR2i734112R3R71R5R79R6tgoR0y47:assets%2Fimages%2Fbonus%2Fsawkillanimation2.xmlR2i3385R3R4R5R80R6tgoR0y63:assets%2Fimages%2Fbonus%2FThis%20is%20here%20for%20Tutorial.txtR2i766R3R4R5R81R6tgoR0y45:assets%2Fimages%2Fcampaign_menu_UI_assets.pngR2i27171R3R71R5R82R6tgoR0y45:assets%2Fimages%2Fcampaign_menu_UI_assets.xmlR2i1893R3R4R5R83R6tgoR0y49:assets%2Fimages%2Fcampaign_menu_UI_characters.pngR2i2285826R3R71R5R84R6tgoR0y49:assets%2Fimages%2Fcampaign_menu_UI_characters.xmlR2i22475R3R4R5R85R6tgoR0y61:assets%2Fimages%2Fcharacters%2FLeft%2FAlt_Agoti_Sprites_B.pngR2i4322364R3R71R5R86R6tgoR0y61:assets%2Fimages%2Fcharacters%2FLeft%2FAlt_Agoti_Sprites_B.xmlR2i6575R3R4R5R87R6tgoR0y56:assets%2Fimages%2Fcharacters%2FLeft%2Fhellbob_assets.pngR2i515190R3R71R5R88R6tgoR0y56:assets%2Fimages%2Fcharacters%2FLeft%2Fhellbob_assets.xmlR2i7359R3R4R5R89R6tgoR0y49:assets%2Fimages%2Fcharacters%2FLeft%2FMadTabi.pngR2i4867855R3R71R5R90R6tgoR0y49:assets%2Fimages%2Fcharacters%2FLeft%2FMadTabi.xmlR2i6923R3R4R5R91R6tgoR0y55:assets%2Fimages%2Fcharacters%2FLeft%2FSenpai_Spirit.pngR2i3086438R3R71R5R92R6tgoR0y55:assets%2Fimages%2Fcharacters%2FLeft%2FSenpai_Spirit.xmlR2i6531R3R4R5R93R6tgoR0y56:assets%2Fimages%2Fcharacters%2FLeft%2Fsky_mad_assets.pngR2i926139R3R71R5R94R6tgoR0y56:assets%2Fimages%2Fcharacters%2FLeft%2Fsky_mad_assets.xmlR2i6612R3R4R5R95R6tgoR0y56:assets%2Fimages%2Fcharacters%2FLeft%2Ftordbot_assets.pngR2i5382572R3R71R5R96R6tgoR0y56:assets%2Fimages%2Fcharacters%2FLeft%2Ftordbot_assets.xmlR2i2728R3R4R5R97R6tgoR0y47:assets%2Fimages%2Fcharacters%2FLeft%2FZardy.pngR2i1683174R3R71R5R98R6tgoR0y47:assets%2Fimages%2Fcharacters%2FLeft%2FZardy.xmlR2i5246R3R4R5R99R6tgoR0y54:assets%2Fimages%2Fcharacters%2FRight%2FBF_post_exp.pngR2i6075824R3R71R5R100R6tgoR0y54:assets%2Fimages%2Fcharacters%2FRight%2FBF_post_exp.xmlR2i71496R3R4R5R101R6tgoR0y62:assets%2Fimages%2Fcharacters%2FRight%2Fgarcellodead_assets.pngR2i4212233R3R71R5R102R6tgoR0y62:assets%2Fimages%2Fcharacters%2FRight%2Fgarcellodead_assets.xmlR2i12061R3R4R5R103R6tgoR0y52:assets%2Fimages%2Fcharacters%2FRight%2FHex_Virus.pngR2i3776075R3R71R5R104R6tgoR0y52:assets%2Fimages%2Fcharacters%2FRight%2FHex_Virus.xmlR2i8510R3R4R5R105R6tgoR0y54:assets%2Fimages%2Fcharacters%2FRight%2Fmatt_assets.pngR2i384034R3R71R5R106R6tgoR0y54:assets%2Fimages%2Fcharacters%2FRight%2Fmatt_assets.xmlR2i9052R3R4R5R107R6tgoR0y59:assets%2Fimages%2Fcharacters%2FRight%2FPico_FNF_assetss.pngR2i1750438R3R71R5R108R6tgoR0y59:assets%2Fimages%2Fcharacters%2FRight%2FPico_FNF_assetss.xmlR2i24093R3R4R5R109R6tgoR0y50:assets%2Fimages%2Fcharacters%2FRight%2Fpshaggy.pngR2i2140362R3R71R5R110R6tgoR0y50:assets%2Fimages%2Fcharacters%2FRight%2Fpshaggy.xmlR2i16817R3R4R5R111R6tgoR0y52:assets%2Fimages%2Fcharacters%2FRight%2Fruv_sheet.pngR2i4483996R3R71R5R112R6tgoR0y52:assets%2Fimages%2Fcharacters%2FRight%2Fruv_sheet.xmlR2i12980R3R4R5R113R6tgoR0y53:assets%2Fimages%2Fcharacters%2FRight%2FTrickyMask.pngR2i4930425R3R71R5R114R6tgoR0y53:assets%2Fimages%2Fcharacters%2FRight%2FTrickyMask.xmlR2i8043R3R4R5R115R6tgoR0y54:assets%2Fimages%2Fcharacters%2FRight%2FWhittyCrazy.pngR2i8266522R3R71R5R116R6tgoR0y54:assets%2Fimages%2Fcharacters%2FRight%2FWhittyCrazy.xmlR2i18254R3R4R5R117R6tgoR0y51:assets%2Fimages%2Fcharacters%2Fthegfs%2Fcarolbg.pngR2i38891R3R71R5R118R6tgoR0y59:assets%2Fimages%2Fcharacters%2Fthegfs%2FCarol_GF_assets.pngR2i7171798R3R71R5R119R6tgoR0y61:assets%2Fimages%2Fcharacters%2Fthegfs%2FDestroyed_boombox.pngR2i78368R3R71R5R120R6tgoR0y60:assets%2Fimages%2Fcharacters%2Fthegfs%2FmonsterChristmas.pngR2i1107462R3R71R5R121R6tgoR0y60:assets%2Fimages%2Fcharacters%2Fthegfs%2FmonsterChristmas.xmlR2i14973R3R4R5R122R6tgoR0y61:assets%2Fimages%2Fcharacters%2Fthegfs%2Fobeebob_and_scoob.pngR2i46883R3R71R5R123R6tgoR0y62:assets%2Fimages%2Fcharacters%2Fthegfs%2Fopheebop_and_scoob.pngR2i46883R3R71R5R124R6tgoR0y60:assets%2Fimages%2Fcharacters%2Fthegfs%2FPostExpGF_Assets.pngR2i668495R3R71R5R125R6tgoR0y60:assets%2Fimages%2Fcharacters%2Fthegfs%2FPostExpGF_Assets.xmlR2i2540R3R4R5R126R6tgoR0y50:assets%2Fimages%2Fcharacters%2Fthegfs%2Fscooby.pngR2i1867262R3R71R5R127R6tgoR0y50:assets%2Fimages%2Fcharacters%2Fthegfs%2Fscooby.xmlR2i22578R3R4R5R128R6tgoR0y50:assets%2Fimages%2Fcharacters%2Fthegfs%2Fshaggy.pngR2i4259348R3R71R5R129R6tgoR0y50:assets%2Fimages%2Fcharacters%2Fthegfs%2Fshaggy.xmlR2i59819R3R4R5R130R6tgoR0y54:assets%2Fimages%2Fcharacters%2Fthegfs%2Ftheseknees.pngR2i2468236R3R71R5R131R6tgoR0y54:assets%2Fimages%2Fcharacters%2Fthegfs%2Ftheseknees.xmlR2i1130R3R4R5R132R6tgoR0y42:assets%2Fimages%2FFNF_main_menu_assets.pngR2i281298R3R71R5R133R6tgoR0y42:assets%2Fimages%2FFNF_main_menu_assets.xmlR2i4755R3R4R5R134R6tgoR0y34:assets%2Fimages%2FgfDanceTitle.pngR2i1221436R3R71R5R135R6tgoR0y34:assets%2Fimages%2FgfDanceTitle.xmlR2i4259R3R4R5R136R6tgoR0y30:assets%2Fimages%2FiconGrid.pngR2i285598R3R71R5R137R6tgoR0y36:assets%2Fimages%2FKadeEngineLogo.pngR2i259663R3R71R5R138R6tgoR0y42:assets%2Fimages%2FKadeEngineLogoBumpin.pngR2i1131603R3R71R5R139R6tgoR0y42:assets%2Fimages%2FKadeEngineLogoBumpin.xmlR2i2187R3R4R5R140R6tgoR0y39:assets%2Fimages%2FKadeEngineLogoOld.pngR2i118097R3R71R5R141R6tgoR0y26:assets%2Fimages%2Flogo.pngR2i86924R3R71R5R142R6tgoR0y32:assets%2Fimages%2FlogoBumpin.pngR2i592724R3R71R5R143R6tgoR0y32:assets%2Fimages%2FlogoBumpin.xmlR2i2177R3R4R5R144R6tgoR0y28:assets%2Fimages%2FmenuBG.pngR2i620342R3R71R5R145R6tgoR0y32:assets%2Fimages%2FmenuBGBlue.pngR2i614586R3R71R5R146R6tgoR0y35:assets%2Fimages%2FmenuBGMagenta.pngR2i553468R3R71R5R147R6tgoR0y31:assets%2Fimages%2FmenuDesat.pngR2i357911R3R71R5R148R6tgoR0y37:assets%2Fimages%2Fnewgrounds_logo.pngR2i57747R3R71R5R149R6tgoR0y26:assets%2Fimages%2Fnum0.pngR2i3738R3R71R5R150R6tgoR0y26:assets%2Fimages%2Fnum1.pngR2i3390R3R71R5R151R6tgoR0y26:assets%2Fimages%2Fnum2.pngR2i3990R3R71R5R152R6tgoR0y26:assets%2Fimages%2Fnum3.pngR2i4022R3R71R5R153R6tgoR0y26:assets%2Fimages%2Fnum4.pngR2i3989R3R71R5R154R6tgoR0y26:assets%2Fimages%2Fnum5.pngR2i4113R3R71R5R155R6tgoR0y26:assets%2Fimages%2Fnum6.pngR2i4181R3R71R5R156R6tgoR0y26:assets%2Fimages%2Fnum7.pngR2i3692R3R71R5R157R6tgoR0y26:assets%2Fimages%2Fnum8.pngR2i3914R3R71R5R158R6tgoR0y26:assets%2Fimages%2Fnum9.pngR2i3687R3R71R5R159R6tgoR0y32:assets%2Fimages%2FQTiconGrid.pngR2i244659R3R71R5R160R6tgoR0y29:assets%2Fimages%2Fshadows.pngR2i137397R3R71R5R161R6tgoR0y39:assets%2Fimages%2Fstorymenu%2Fweek0.pngR2i7056R3R71R5R162R6tgoR0y39:assets%2Fimages%2Fstorymenu%2Fweek1.pngR2i6261R3R71R5R163R6tgoR0y39:assets%2Fimages%2Fstorymenu%2Fweek2.pngR2i6517R3R71R5R164R6tgoR0y39:assets%2Fimages%2Fstorymenu%2Fweek3.pngR2i7148R3R71R5R165R6tgoR0y39:assets%2Fimages%2Fstorymenu%2Fweek4.pngR2i6262R3R71R5R166R6tgoR0y39:assets%2Fimages%2Fstorymenu%2Fweek5.pngR2i6440R3R71R5R167R6tgoR0y39:assets%2Fimages%2Fstorymenu%2Fweek6.pngR2i8345R3R71R5R168R6tgoR0y32:assets%2Fimages%2FtitleEnter.pngR2i1449202R3R71R5R169R6tgoR0y32:assets%2Fimages%2FtitleEnter.xmlR2i4875R3R4R5R170R6tgoR0y58:assets%2Fimages%2Fweeb%2FdialogShit%2FdialogueBox-evil.pngR2i1425R3R71R5R171R6tgoR0y58:assets%2Fimages%2Fweeb%2FdialogShit%2FdialogueBox-evil.xmlR2i1385R3R4R5R172R6tgoR0y59:assets%2Fimages%2Fweeb%2FdialogShit%2FdialogueBox-pixel.pngR2i7200R3R71R5R173R6tgoR0y59:assets%2Fimages%2Fweeb%2FdialogShit%2FdialogueBox-pixel.xmlR2i680R3R4R5R174R6tgoR0y63:assets%2Fimages%2Fweeb%2FdialogShit%2FdialogueBox-senpaiMad.pngR2i26689R3R71R5R175R6tgoR0y63:assets%2Fimages%2Fweeb%2FdialogShit%2FdialogueBox-senpaiMad.xmlR2i1050R3R4R5R176R6tgoR0y54:assets%2Fimages%2Fweeb%2FdialogShit%2Fhand_textbox.pngR2i260R3R71R5R177R6tgoR0y51:assets%2Fimages%2Fweeb%2FpixelUI%2Fhand_textbox.pngR2i260R3R71R5R178R6tgoR0y40:assets%2Fimages%2Fweeb%2FsenpaiCrazy.pngR2i14142R3R71R5R179R6tgoR0y40:assets%2Fimages%2Fweeb%2FsenpaiCrazy.xmlR2i19805R3R4R5R180R6tgoR2i2309657R3y5:MUSICR5y31:assets%2Fmusic%2FfreakyMenu.mp3y9:pathGroupaR182hR6tgoR2i17762R3R181R5y32:assets%2Fsounds%2FcancelMenu.mp3R183aR184hR6tgoR2i91950R3R181R5y33:assets%2Fsounds%2FconfirmMenu.mp3R183aR185hR6tgoR2i17762R3R181R5y32:assets%2Fsounds%2FscrollMenu.mp3R183aR186hR6tgoR0y46:assets%2Fvideos%2FdaWeirdVid%2FdontDelete.webmR2i10965R3R65R5R187R6tgoR0y80:assets%2Fvideos%2FDO%20NOT%20DELETE%20OR%20GAME%20WILL%20CRASH%2FdontDelete.webmR2i10965R3R65R5R188R6tgoR0y45:assets%2Fvideos%2FHankFuckingShootsTricky.txtR2i3R3R4R5R189R6tgoR0y46:assets%2Fvideos%2FHankFuckingShootsTricky.webmR2i7825863R3R65R5R190R6tgoR0y40:assets%2Fvideos%2FHELLCLOWN_ENGADGED.txtR2i3R3R4R5R191R6tgoR0y41:assets%2Fvideos%2FHELLCLOWN_ENGADGED.webmR2i11736317R3R65R5R192R6tgoR0y34:assets%2Fvideos%2FTestVid.mp4R2i2909007R3R65R5R194R6tgoR0y40:assets%2Fvideos%2Fvideos%20go%20here.txtR2zR3R4R5R195R6tgoR0y48:mods%2FintroMod%2F_append%2Fdata%2FintroText.txtR2i20R3R4R5R196goR0y18:mods%2FmodList.txtR2i8R3R4R5R197goR0y17:mods%2Freadme.txtR2i90R3R4R5R198goR0y21:do%20NOT%20readme.txtR2i4326R3R4R5R199R6tgoR0y11:LICENSE.txtR2i11407R3R4R5R200R6tgoR0y34:assets%2Ffonts%2Ffonts-go-here.txtR2zR3R4R5R201R6tgoR2i14656R3y4:FONTy9:classNamey31:__ASSET__assets_fonts_pixel_otfR5y26:assets%2Ffonts%2Fpixel.otfR6tgoR2i75864R3R202R203y29:__ASSET__assets_fonts_vcr_ttfR5y24:assets%2Ffonts%2Fvcr.ttfR6tgoR2i2114R3R181R5y26:flixel%2Fsounds%2Fbeep.mp3R183aR208y26:flixel%2Fsounds%2Fbeep.ogghR6tgoR2i39706R3R181R5y28:flixel%2Fsounds%2Fflixel.mp3R183aR210y28:flixel%2Fsounds%2Fflixel.ogghR6tgoR2i5794R3y5:SOUNDR5R209R183aR208R209hgoR2i33629R3R212R5R211R183aR210R211hgoR2i15744R3R202R203y35:__ASSET__flixel_fonts_nokiafc22_ttfR5y30:flixel%2Ffonts%2Fnokiafc22.ttfR6tgoR2i29724R3R202R203y36:__ASSET__flixel_fonts_monsterrat_ttfR5y31:flixel%2Ffonts%2Fmonsterrat.ttfR6tgoR0y33:flixel%2Fimages%2Fui%2Fbutton.pngR2i519R3R71R5R217R6tgoR0y36:flixel%2Fimages%2Flogo%2Fdefault.pngR2i3280R3R71R5R218R6tgoR0y34:flixel%2Fflixel-ui%2Fimg%2Fbox.pngR2i912R3R71R5R219R6tgoR0y37:flixel%2Fflixel-ui%2Fimg%2Fbutton.pngR2i433R3R71R5R220R6tgoR0y48:flixel%2Fflixel-ui%2Fimg%2Fbutton_arrow_down.pngR2i446R3R71R5R221R6tgoR0y48:flixel%2Fflixel-ui%2Fimg%2Fbutton_arrow_left.pngR2i459R3R71R5R222R6tgoR0y49:flixel%2Fflixel-ui%2Fimg%2Fbutton_arrow_right.pngR2i511R3R71R5R223R6tgoR0y46:flixel%2Fflixel-ui%2Fimg%2Fbutton_arrow_up.pngR2i493R3R71R5R224R6tgoR0y42:flixel%2Fflixel-ui%2Fimg%2Fbutton_thin.pngR2i247R3R71R5R225R6tgoR0y44:flixel%2Fflixel-ui%2Fimg%2Fbutton_toggle.pngR2i534R3R71R5R226R6tgoR0y40:flixel%2Fflixel-ui%2Fimg%2Fcheck_box.pngR2i922R3R71R5R227R6tgoR0y41:flixel%2Fflixel-ui%2Fimg%2Fcheck_mark.pngR2i946R3R71R5R228R6tgoR0y37:flixel%2Fflixel-ui%2Fimg%2Fchrome.pngR2i253R3R71R5R229R6tgoR0y42:flixel%2Fflixel-ui%2Fimg%2Fchrome_flat.pngR2i212R3R71R5R230R6tgoR0y43:flixel%2Fflixel-ui%2Fimg%2Fchrome_inset.pngR2i192R3R71R5R231R6tgoR0y43:flixel%2Fflixel-ui%2Fimg%2Fchrome_light.pngR2i214R3R71R5R232R6tgoR0y44:flixel%2Fflixel-ui%2Fimg%2Fdropdown_mark.pngR2i156R3R71R5R233R6tgoR0y41:flixel%2Fflixel-ui%2Fimg%2Ffinger_big.pngR2i1724R3R71R5R234R6tgoR0y43:flixel%2Fflixel-ui%2Fimg%2Ffinger_small.pngR2i294R3R71R5R235R6tgoR0y38:flixel%2Fflixel-ui%2Fimg%2Fhilight.pngR2i129R3R71R5R236R6tgoR0y36:flixel%2Fflixel-ui%2Fimg%2Finvis.pngR2i128R3R71R5R237R6tgoR0y41:flixel%2Fflixel-ui%2Fimg%2Fminus_mark.pngR2i136R3R71R5R238R6tgoR0y40:flixel%2Fflixel-ui%2Fimg%2Fplus_mark.pngR2i147R3R71R5R239R6tgoR0y36:flixel%2Fflixel-ui%2Fimg%2Fradio.pngR2i191R3R71R5R240R6tgoR0y40:flixel%2Fflixel-ui%2Fimg%2Fradio_dot.pngR2i153R3R71R5R241R6tgoR0y37:flixel%2Fflixel-ui%2Fimg%2Fswatch.pngR2i185R3R71R5R242R6tgoR0y34:flixel%2Fflixel-ui%2Fimg%2Ftab.pngR2i201R3R71R5R243R6tgoR0y39:flixel%2Fflixel-ui%2Fimg%2Ftab_back.pngR2i210R3R71R5R244R6tgoR0y44:flixel%2Fflixel-ui%2Fimg%2Ftooltip_arrow.pngR2i18509R3R71R5R245R6tgoR0y39:flixel%2Fflixel-ui%2Fxml%2Fdefaults.xmlR2i1263R3R4R5R246R6tgoR0y53:flixel%2Fflixel-ui%2Fxml%2Fdefault_loading_screen.xmlR2i1953R3R4R5R247R6tgoR0y44:flixel%2Fflixel-ui%2Fxml%2Fdefault_popup.xmlR2i1848R3R4R5R248R6tgh\",\"rootPath\":null,\"version\":2,\"libraryArgs\":[],\"libraryType\":null}"
*/