#define GUI_GRID_X	(0)
#define GUI_GRID_Y	(0)
#define GUI_GRID_W	(0.025)
#define GUI_GRID_H	(0.04)
#define GUI_GRID_WAbs	(1)
#define GUI_GRID_HAbs	(1)

///////////////////////////////////////////////////////////////////////////
/// Styles
///////////////////////////////////////////////////////////////////////////

// Control types
#define CT_STATIC           0
#define CT_BUTTON           1
#define CT_EDIT             2
#define CT_SLIDER           3
#define CT_COMBO            4
#define CT_LISTBOX          5
#define CT_TOOLBOX          6
#define CT_CHECKBOXES       7
#define CT_PROGRESS         8
#define CT_HTML             9
#define CT_STATIC_SKEW      10
#define CT_ACTIVETEXT       11
#define CT_TREE             12
#define CT_STRUCTURED_TEXT  13
#define CT_CONTEXT_MENU     14
#define CT_CONTROLS_GROUP   15
#define CT_SHORTCUTBUTTON   16
#define CT_XKEYDESC         40
#define CT_XBUTTON          41
#define CT_XLISTBOX         42
#define CT_XSLIDER          43
#define CT_XCOMBO           44
#define CT_ANIMATED_TEXTURE 45
#define CT_OBJECT           80
#define CT_OBJECT_ZOOM      81
#define CT_OBJECT_CONTAINER 82
#define CT_OBJECT_CONT_ANIM 83
#define CT_LINEBREAK        98
#define CT_USER             99
#define CT_MAP              100
#define CT_MAP_MAIN         101
#define CT_LISTNBOX         102
#define CT_CHECKBOX         77

// Static styles
#define ST_POS            0x0F
#define ST_HPOS           0x03
#define ST_VPOS           0x0C
#define ST_LEFT           0x00
#define ST_RIGHT          0x01
#define ST_CENTER         0x02
#define ST_DOWN           0x04
#define ST_UP             0x08
#define ST_VCENTER        0x0C

#define ST_TYPE           0xF0
#define ST_SINGLE         0x00
#define ST_MULTI          0x10
#define ST_TITLE_BAR      0x20
#define ST_PICTURE        0x30
#define ST_FRAME          0x40
#define ST_BACKGROUND     0x50
#define ST_GROUP_BOX      0x60
#define ST_GROUP_BOX2     0x70
#define ST_HUD_BACKGROUND 0x80
#define ST_TILE_PICTURE   0x90
#define ST_WITH_RECT      0xA0
#define ST_LINE           0xB0

#define ST_SHADOW         0x100
#define ST_NO_RECT        0x200
#define ST_KEEP_ASPECT_RATIO  0x800

#define ST_TITLE          ST_TITLE_BAR + ST_CENTER

// Slider styles
#define SL_DIR            0x400
#define SL_VERT           0
#define SL_HORZ           0x400

#define SL_TEXTURES       0x10

// progress bar 
#define ST_VERTICAL       0x01
#define ST_HORIZONTAL     0

// Listbox styles
#define LB_TEXTURES       0x10
#define LB_MULTI          0x20

// Tree styles
#define TR_SHOWROOT       1
#define TR_AUTOCOLLAPSE   2

// MessageBox styles
#define MB_BUTTON_OK      1
#define MB_BUTTON_CANCEL  2
#define MB_BUTTON_USER    4


///////////////////////////////////////////////////////////////////////////
/// Base Classes
///////////////////////////////////////////////////////////////////////////
class SAC_RscText
{
	access = 0;
	type = 0;
	idc = -1;
	colorBackground[] = {0,0,0,0};
	colorText[] = {1,1,1,0.75};
	text = "";
	fixedWidth = 0;
	x = 0;
	y = 0;
	h = 0.037;
	w = 0.3;
	style = 0;
	shadow = 0;
	colorShadow[] = 
	{
		0,
		0,
		0,
		0.5
	};
	font = "PuristaMedium";
	SizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
	linespacing = 1;
	tooltipColorText[] = 
	{
		1,
		1,
		1,
		1
	};
	tooltipColorBox[] = 
	{
		1,
		1,
		1,
		1
	};
	tooltipColorShade[] = 
	{
		0,
		0,
		0,
		0.65
	};
};
class SAC_RscButton
{
	access = 0;
	type = 1;
	text = "";
	colorText[] = {0.9,0.9,0.9,1};
	//colorText[] = {0.18,0.5,0.5,1};
	colorDisabled[] = {0.5,0.5,0.5,1}; //no importa
	colorBackground[] = {0,0,0,0};
	colorBackgroundDisabled[] = {0,0,0,0}; //no importa
	colorBackgroundActive[] = {0.6,0.6,0.6,0.75};
	colorFocused[] = {0,0,0,0}; //siempre igual que colorBackground
	colorShadow[] = {0,0,0,0};
	colorBorder[] = {0,0,0,0};
	soundEnter[] = 
	{
		"\A3\ui_f\data\sound\RscButton\soundEnter",
		0.09,
		1
	};
	soundPush[] = 
	{
		"\A3\ui_f\data\sound\RscButton\soundPush",
		0.09,
		1
	};
	soundClick[] = 
	{
		"\A3\ui_f\data\sound\RscButton\soundClick",
		0.09,
		1
	};
	soundEscape[] = 
	{
		"\A3\ui_f\data\sound\RscButton\soundEscape",
		0.09,
		1
	};
	style = 2;
	x = 0;
	y = 0;
	w = 0.095589;
	h = 0.039216;
	shadow = 0;
	font = "PuristaMedium";
	sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
	borderSize = 0;
	offsetX = 0.003;
	offsetY = 0.003;
	offsetPressedX = 0.002;
	offsetPressedY = 0.002;
	period = 1.2;
	periodFocus = 1.2;
	periodOver = 1.2;
};
class SAC_RscFrame
{
	type = 0;
	idc = -1;
	style = 64;
	shadow = 0;
	colorBackground[] = {1,0,0,1}; //no importa
	//colorText[] = {1,0.70196,0,1};
	//colorText[] = {0.18,0.5,0.5,1};
	colorText[] = {0.9,0.9,0.9,1};
	font = "PuristaMedium";
	sizeEx = 0.02;
	text = "";
};

////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by Sebastian, v1.063, #Nuzifa)
////////////////////////////////////////////////////////
class SAC_4x16_panel
{
	idd = 3000;
	movingenable = 0;

	class Controls
	{
		class MyBackground: SAC_RscText
		{
			idc = 2200;
			x = -0.5 * GUI_GRID_W + GUI_GRID_X;
			y = -0.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 41.5 * GUI_GRID_W;
			h = 26 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0.5};
			//colorBackground[] = {0,0,0,0.7};
			//colorBackground[] = {0,0,0,1};
		};
		class RscFrame_1800: SAC_RscFrame
		{
			idc = 1800;
			text = "";
			x = 0 * GUI_GRID_W + GUI_GRID_X;
			y = -0.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 40.5 * GUI_GRID_W;
			h = 25 * GUI_GRID_H;
			sizeEx = 0.04;
		};
		class RscButton_1600: SAC_RscButton
		{
			idc = 1601;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 0.5 * GUI_GRID_W + GUI_GRID_X;
			y = 0.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1601: SAC_RscButton
		{
			idc = 1602;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 0.5 * GUI_GRID_W + GUI_GRID_X;
			y = 2 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1602: SAC_RscButton
		{
			idc = 1603;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 0.5 * GUI_GRID_W + GUI_GRID_X;
			y = 3.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1603: SAC_RscButton
		{
			idc = 1604;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 0.5 * GUI_GRID_W + GUI_GRID_X;
			y = 5 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1604: SAC_RscButton
		{
			idc = 1605;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 0.5 * GUI_GRID_W + GUI_GRID_X;
			y = 6.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1605: SAC_RscButton
		{
			idc = 1606;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 0.5 * GUI_GRID_W + GUI_GRID_X;
			y = 8 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1606: SAC_RscButton
		{
			idc = 1607;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 0.5 * GUI_GRID_W + GUI_GRID_X;
			y = 9.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1607: SAC_RscButton
		{
			idc = 1608;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 0.5 * GUI_GRID_W + GUI_GRID_X;
			y = 11 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1608: SAC_RscButton
		{
			idc = 1609;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 0.5 * GUI_GRID_W + GUI_GRID_X;
			y = 12.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1609: SAC_RscButton
		{
			idc = 1610;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 0.5 * GUI_GRID_W + GUI_GRID_X;
			y = 14 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1610: SAC_RscButton
		{
			idc = 1611;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 0.5 * GUI_GRID_W + GUI_GRID_X;
			y = 15.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1611: SAC_RscButton
		{
			idc = 1612;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 0.5 * GUI_GRID_W + GUI_GRID_X;
			y = 17 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			// colorBackground[] = {0.7,0.7,0,0.3};
			// colorFocused[] = {0.7,0.7,0,0.3};
			// colorBackgroundActive[] = {0.9,0.9,0,0.3};
		};
		class RscButton_1612: SAC_RscButton
		{
			idc = 1613;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 0.5 * GUI_GRID_W + GUI_GRID_X;
			y = 18.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1613: SAC_RscButton
		{
			idc = 1614;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 0.5 * GUI_GRID_W + GUI_GRID_X;
			y = 20 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1614: SAC_RscButton
		{
			idc = 1615;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 0.5 * GUI_GRID_W + GUI_GRID_X;
			y = 21.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1615: SAC_RscButton
		{
			idc = 1616;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 0.5 * GUI_GRID_W + GUI_GRID_X;
			y = 23 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1616: SAC_RscButton
		{
			idc = 1617;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 11 * GUI_GRID_W + GUI_GRID_X;
			y = 0.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1617: SAC_RscButton
		{
			idc = 1618;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 11 * GUI_GRID_W + GUI_GRID_X;
			y = 2 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1618: SAC_RscButton
		{
			idc = 1619;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 11 * GUI_GRID_W + GUI_GRID_X;
			y = 3.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1619: SAC_RscButton
		{
			idc = 1620;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 11 * GUI_GRID_W + GUI_GRID_X;
			y = 5 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1620: SAC_RscButton
		{
			idc = 1621;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 11 * GUI_GRID_W + GUI_GRID_X;
			y = 6.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1621: SAC_RscButton
		{
			idc = 1622;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 11 * GUI_GRID_W + GUI_GRID_X;
			y = 8 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1622: SAC_RscButton
		{
			idc = 1623;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 11 * GUI_GRID_W + GUI_GRID_X;
			y = 9.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1623: SAC_RscButton
		{
			idc = 1624;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 11 * GUI_GRID_W + GUI_GRID_X;
			y = 11 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1624: SAC_RscButton
		{
			idc = 1625;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 11 * GUI_GRID_W + GUI_GRID_X;
			y = 12.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			// colorBackground[] = {0.5,0,0,0.5};
			// colorBackgroundActive[] = {0.7,0,0,0.5};
			// colorFocused[] = {0.5,0,0,0.5};
		};
		class RscButton_1625: SAC_RscButton
		{
			idc = 1626;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 11 * GUI_GRID_W + GUI_GRID_X;
			y = 14 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1626: SAC_RscButton
		{
			idc = 1627;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 11 * GUI_GRID_W + GUI_GRID_X;
			y = 15.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1627: SAC_RscButton
		{
			idc = 1628;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 11 * GUI_GRID_W + GUI_GRID_X;
			y = 17 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			// colorBackground[] = {0.7,0.7,0,0.3};
			// colorFocused[] = {0.7,0.7,0,0.3};
			// colorBackgroundActive[] = {0.9,0.9,0,0.3};
		};
		class RscButton_1628: SAC_RscButton
		{
			idc = 1629;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 11 * GUI_GRID_W + GUI_GRID_X;
			y = 18.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1629: SAC_RscButton
		{
			idc = 1630;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 11 * GUI_GRID_W + GUI_GRID_X;
			y = 20 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1630: SAC_RscButton
		{
			idc = 1631;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 11 * GUI_GRID_W + GUI_GRID_X;
			y = 21.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1631: SAC_RscButton
		{
			idc = 1632;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 11 * GUI_GRID_W + GUI_GRID_X;
			y = 23 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1632: SAC_RscButton
		{
			idc = 1633;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 22 * GUI_GRID_W + GUI_GRID_X;
			y = 0.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1633: SAC_RscButton
		{
			idc = 1634;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 22 * GUI_GRID_W + GUI_GRID_X;
			y = 2 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1634: SAC_RscButton
		{
			idc = 1635;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 22 * GUI_GRID_W + GUI_GRID_X;
			y = 3.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1635: SAC_RscButton
		{
			idc = 1636;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 22 * GUI_GRID_W + GUI_GRID_X;
			y = 5 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1636: SAC_RscButton
		{
			idc = 1637;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 22 * GUI_GRID_W + GUI_GRID_X;
			y = 6.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1637: SAC_RscButton
		{
			idc = 1638;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 22 * GUI_GRID_W + GUI_GRID_X;
			y = 8 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1638: SAC_RscButton
		{
			idc = 1639;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 22 * GUI_GRID_W + GUI_GRID_X;
			y = 9.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1639: SAC_RscButton
		{
			idc = 1640;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 22 * GUI_GRID_W + GUI_GRID_X;
			y = 11 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1640: SAC_RscButton
		{
			idc = 1641;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 22 * GUI_GRID_W + GUI_GRID_X;
			y = 12.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1641: SAC_RscButton
		{
			idc = 1642;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 22 * GUI_GRID_W + GUI_GRID_X;
			y = 14 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1642: SAC_RscButton
		{
			idc = 1643;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 22 * GUI_GRID_W + GUI_GRID_X;
			y = 15.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1643: SAC_RscButton
		{
			idc = 1644;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 22 * GUI_GRID_W + GUI_GRID_X;
			y = 17 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1644: SAC_RscButton
		{
			idc = 1645;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 22 * GUI_GRID_W + GUI_GRID_X;
			y = 18.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1645: SAC_RscButton
		{
			idc = 1646;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 22 * GUI_GRID_W + GUI_GRID_X;
			y = 20 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1646: SAC_RscButton
		{
			idc = 1647;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 22 * GUI_GRID_W + GUI_GRID_X;
			y = 21.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1647: SAC_RscButton
		{
			idc = 1648;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 22 * GUI_GRID_W + GUI_GRID_X;
			y = 23 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1648: SAC_RscButton
		{
			idc = 1649;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 32.5 * GUI_GRID_W + GUI_GRID_X;
			y = 0.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1649: SAC_RscButton
		{
			idc = 1650;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 32.5 * GUI_GRID_W + GUI_GRID_X;
			y = 2 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1650: SAC_RscButton
		{
			idc = 1651;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 32.5 * GUI_GRID_W + GUI_GRID_X;
			y = 3.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1651: SAC_RscButton
		{
			idc = 1652;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 32.5 * GUI_GRID_W + GUI_GRID_X;
			y = 5 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1652: SAC_RscButton
		{
			idc = 1653;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 32.5 * GUI_GRID_W + GUI_GRID_X;
			y = 6.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1653: SAC_RscButton
		{
			idc = 1654;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 32.5 * GUI_GRID_W + GUI_GRID_X;
			y = 8 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1654: SAC_RscButton
		{
			idc = 1655;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 32.5 * GUI_GRID_W + GUI_GRID_X;
			y = 9.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1655: SAC_RscButton
		{
			idc = 1656;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 32.5 * GUI_GRID_W + GUI_GRID_X;
			y = 11 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1656: SAC_RscButton
		{
			idc = 1657;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 32.5 * GUI_GRID_W + GUI_GRID_X;
			y = 12.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1657: SAC_RscButton
		{
			idc = 1658;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 32.5 * GUI_GRID_W + GUI_GRID_X;
			y = 14 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1658: SAC_RscButton
		{
			idc = 1659;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 32.5 * GUI_GRID_W + GUI_GRID_X;
			y = 15.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1659: SAC_RscButton
		{
			idc = 1660;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 32.5 * GUI_GRID_W + GUI_GRID_X;
			y = 17 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1660: SAC_RscButton
		{
			idc = 1661;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 32.5 * GUI_GRID_W + GUI_GRID_X;
			y = 18.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1661: SAC_RscButton
		{
			idc = 1662;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 32.5 * GUI_GRID_W + GUI_GRID_X;
			y = 20 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1662: SAC_RscButton
		{
			idc = 1663;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 32.5 * GUI_GRID_W + GUI_GRID_X;
			y = 21.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscButton_1663: SAC_RscButton
		{
			idc = 1664;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 32.5 * GUI_GRID_W + GUI_GRID_X;
			y = 23 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
	};
};

class SAC_RscText_2
{
	access = 0;
	type = 0;
	idc = -1;
	colorBackground[] = {0,0,0,0};
	colorText[] = {1,1,1,0.75};
	text = "";
	fixedWidth = 0;
	x = 0;
	y = 0;
	h = 0.037;
	w = 0.3;
	style = 0;
	shadow = 0;
	font = "puristaMedium";
	SizeEx = "0.03921 * 0.8";
};

class SAC_RscButton_2
{
	access = 0;
	type = 1;
	text = "";
	colorText[] = {0.9,0.9,0.9,1};
	//colorText[] = {0.18,0.5,0.5,1};
	colorDisabled[] = {0.5,0.5,0.5,1}; //no importa
	colorBackground[] = {0,0,0,0};
	colorBackgroundDisabled[] = {0,0,0,0}; //no importa
	colorBackgroundActive[] = {0.6,0.6,0.6,0.75};
	colorFocused[] = {0,0,0,0}; //siempre igual que colorBackground
	colorShadow[] = {0,0,0,0};
	colorBorder[] = {0,0,0,0};
	soundEnter[] = {"\A3\ui_f\data\sound\RscButton\soundEnter",0.09,1};
	soundPush[] = {"\A3\ui_f\data\sound\RscButton\soundPush",0,0};
	soundClick[] = {"\A3\ui_f\data\sound\RscButton\soundClick",0.07,1};
	soundEscape[] = {"\A3\ui_f\data\sound\RscButton\soundEscape",0.09,1};
	style = 2;
	x = 0;
	y = 0;
	w = 0.095589;
	h = 0.039216;
	shadow = 0;
	font = "puristaMedium";
	sizeEx = 0.03921;
	offsetX = 0.003;
	offsetY = 0.003;
	offsetPressedX = 0.002;
	offsetPressedY = 0.002;
	borderSize = 0;
};

class SAC_RscFrame_2
{
	type = 0;
	idc = -1;
	style = 64;
	shadow = 0;
	colorBackground[] = {0,0,0,1}; //no importa
	//colorText[] = {1,0.70196,0,1};
	//colorText[] = {0.18,0.5,0.5,1};
	colorText[] = {0.9,0.9,0.9,1};
	font = "puristaMedium";
	sizeEx = 0.02;
	text = "";
};

class SAC_2x12_panel
{
	idd = 3000;
	movingenable = 0;

	class Controls
	{
		class MyBackground: SAC_RscText_2
		{
			idc = 1000;
			x = 0.279165 * safezoneW + safezoneX;
			y = 0.237245 * safezoneH + safezoneY;
			w = 0.441667 * safezoneW;
			h = 0.561745 * safezoneH;
			colorBackground[] = {0,0,0,0.5};
			//colorBackground[] = {0,0,0,1};
		};
		class RscFrame_1800: SAC_RscFrame_2
		{
			idc = 1800;
			text = "";
			x = 0.279165 * safezoneW + safezoneX;
			y = 0.237245 * safezoneH + safezoneY;
			w = 0.441667 * safezoneW;
			h = 0.561745 * safezoneH;
			sizeEx = 0.04;
		};
		class RscButton_1600: SAC_RscButton_2
		{
			idc = 1601;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 0.29 * safezoneW + safezoneX;
			y = 0.280086 * safezoneH + safezoneY;
			w = 0.2 * safezoneW;
			h = 0.0287388 * safezoneH;
		};
		class RscButton_1601: SAC_RscButton_2
		{
			idc = 1602;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 0.29 * safezoneW + safezoneX;
			y = 0.32132 * safezoneH + safezoneY;
			w = 0.2 * safezoneW;
			h = 0.0287388 * safezoneH;
		};
		class RscButton_1602: SAC_RscButton_2
		{
			idc = 1603;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 0.29 * safezoneW + safezoneX;
			y = 0.362554 * safezoneH + safezoneY;
			w = 0.2 * safezoneW;
			h = 0.0287388 * safezoneH;
		};
		class RscButton_1603: SAC_RscButton_2
		{
			idc = 1604;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 0.29 * safezoneW + safezoneX;
			y = 0.403788 * safezoneH + safezoneY;
			w = 0.2 * safezoneW;
			h = 0.0287388 * safezoneH;
		};
		class RscButton_1604: SAC_RscButton_2
		{
			idc = 1605;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 0.29 * safezoneW + safezoneX;
			y = 0.445021 * safezoneH + safezoneY;
			w = 0.2 * safezoneW;
			h = 0.0287388 * safezoneH;
		};
		class RscButton_1605: SAC_RscButton_2
		{
			idc = 1606;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 0.29 * safezoneW + safezoneX;
			y = 0.486255 * safezoneH + safezoneY;
			w = 0.2 * safezoneW;
			h = 0.0287388 * safezoneH;
		};
		class RscButton_1606: SAC_RscButton_2
		{
			idc = 1607;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 0.29 * safezoneW + safezoneX;
			y = 0.527489 * safezoneH + safezoneY;
			w = 0.2 * safezoneW;
			h = 0.0287388 * safezoneH;
		};
		class RscButton_1607: SAC_RscButton_2
		{
			idc = 1608;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 0.29 * safezoneW + safezoneX;
			y = 0.568723 * safezoneH + safezoneY;
			w = 0.2 * safezoneW;
			h = 0.0287388 * safezoneH;
		};
		class RscButton_1608: SAC_RscButton_2
		{
			idc = 1609;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 0.29 * safezoneW + safezoneX;
			y = 0.609957 * safezoneH + safezoneY;
			w = 0.2 * safezoneW;
			h = 0.0287388 * safezoneH;
		};
		class RscButton_1609: SAC_RscButton_2
		{
			idc = 1610;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 0.29 * safezoneW + safezoneX;
			y = 0.651191 * safezoneH + safezoneY;
			w = 0.2 * safezoneW;
			h = 0.0287388 * safezoneH;
		};
		class RscButton_1610: SAC_RscButton_2
		{
			idc = 1611;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 0.29 * safezoneW + safezoneX;
			y = 0.692425 * safezoneH + safezoneY;
			w = 0.2 * safezoneW;
			h = 0.0287388 * safezoneH;
		};
		class RscButton_1611: SAC_RscButton_2
		{
			idc = 1612;
			text = "";
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 0.29 * safezoneW + safezoneX;
			y = 0.733659 * safezoneH + safezoneY;
			w = 0.2 * safezoneW;
			h = 0.0287388 * safezoneH;
		};
		//column 2
		class RscButton_1612: SAC_RscButton_2
		{
			idc = 1613;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 0.495 * safezoneW + safezoneX;
			y = 0.280086 * safezoneH + safezoneY;
			w = 0.2 * safezoneW;
			h = 0.0287388 * safezoneH;
		};
		class RscButton_1613: SAC_RscButton_2
		{
			idc = 1614;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 0.495 * safezoneW + safezoneX;
			y = 0.32132 * safezoneH + safezoneY;
			w = 0.2 * safezoneW;
			h = 0.0287388 * safezoneH;
		};
		class RscButton_1614: SAC_RscButton_2
		{
			idc = 1615;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 0.495 * safezoneW + safezoneX;
			y = 0.362554 * safezoneH + safezoneY;
			w = 0.2 * safezoneW;
			h = 0.0287388 * safezoneH;
		};
		class RscButton_1615: SAC_RscButton_2
		{
			idc = 1616;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 0.495 * safezoneW + safezoneX;
			y = 0.403788 * safezoneH + safezoneY;
			w = 0.2 * safezoneW;
			h = 0.0287388 * safezoneH;
		};
		class RscButton_1616: SAC_RscButton_2
		{
			idc = 1617;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 0.495 * safezoneW + safezoneX;
			y = 0.445021 * safezoneH + safezoneY;
			w = 0.2 * safezoneW;
			h = 0.0287388 * safezoneH;
		};
		class RscButton_1617: SAC_RscButton_2
		{
			idc = 1618;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 0.495 * safezoneW + safezoneX;
			y = 0.486255 * safezoneH + safezoneY;
			w = 0.2 * safezoneW;
			h = 0.0287388 * safezoneH;
		};
		class RscButton_1618: SAC_RscButton_2
		{
			idc = 1619;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 0.495 * safezoneW + safezoneX;
			y = 0.527489 * safezoneH + safezoneY;
			w = 0.2 * safezoneW;
			h = 0.0287388 * safezoneH;
		};
		class RscButton_1619: SAC_RscButton_2
		{
			idc = 1620;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 0.495 * safezoneW + safezoneX;
			y = 0.568723 * safezoneH + safezoneY;
			w = 0.2 * safezoneW;
			h = 0.0287388 * safezoneH;
		};
		class RscButton_1620: SAC_RscButton_2
		{
			idc = 1621;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 0.495 * safezoneW + safezoneX;
			y = 0.609957 * safezoneH + safezoneY;
			w = 0.2 * safezoneW;
			h = 0.0287388 * safezoneH;
		};
		class RscButton_1621: SAC_RscButton_2
		{
			idc = 1622;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 0.495 * safezoneW + safezoneX;
			y = 0.651191 * safezoneH + safezoneY;
			w = 0.2 * safezoneW;
			h = 0.0287388 * safezoneH;
		};
		class RscButton_1622: SAC_RscButton_2
		{
			idc = 1623;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 0.495 * safezoneW + safezoneX;
			y = 0.692425 * safezoneH + safezoneY;
			w = 0.2 * safezoneW;
			h = 0.0287388 * safezoneH;
		};
		class RscButton_1623: SAC_RscButton_2
		{
			idc = 1624;
			text = "";
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 0.495 * safezoneW + safezoneX;
			y = 0.733659 * safezoneH + safezoneY;
			w = 0.2 * safezoneW;
			h = 0.0287388 * safezoneH;
		};
	};
};

class SAC_1x14_panel
{
	idd = 3000;
	movingenable = 0;

	class Controls
	{
		class MyBackground: SAC_RscText_2
		{
			idc = 1000;
			x = 0.279165 * safezoneW + safezoneX;
			y = 0.237245 * safezoneH + safezoneY;
			w = 0.441667 * safezoneW;
			h = 0.630511 * safezoneH;
			colorBackground[] = {0,0,0,0.5};
			//colorBackground[] = {0,0,0,0.7};
			//colorBackground[] = {0,0,0,1};
		};
		class RscFrame_1800: SAC_RscFrame_2
		{
			idc = 1800;
			text = "";
			x = 0.279165 * safezoneW + safezoneX;
			y = 0.237245 * safezoneH + safezoneY;
			w = 0.441667 * safezoneW;
			h = 0.630511 * safezoneH;
			sizeEx = 0.04;
		};
		class RscButton_1600: SAC_RscButton_2
		{
			idc = 1601;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 0.39 * safezoneW + safezoneX;
			y = 0.280086 * safezoneH + safezoneY;
			w = 0.2 * safezoneW;
			h = 0.0287388 * safezoneH;
		};
		class RscButton_1601: SAC_RscButton_2
		{
			idc = 1602;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 0.39 * safezoneW + safezoneX;
			y = 0.32132 * safezoneH + safezoneY;
			w = 0.2 * safezoneW;
			h = 0.0287388 * safezoneH;
		};
		class RscButton_1602: SAC_RscButton_2
		{
			idc = 1603;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 0.39 * safezoneW + safezoneX;
			y = 0.362554 * safezoneH + safezoneY;
			w = 0.2 * safezoneW;
			h = 0.0287388 * safezoneH;
		};
		class RscButton_1603: SAC_RscButton_2
		{
			idc = 1604;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 0.39 * safezoneW + safezoneX;
			y = 0.403788 * safezoneH + safezoneY;
			w = 0.2 * safezoneW;
			h = 0.0287388 * safezoneH;
		};
		class RscButton_1604: SAC_RscButton_2
		{
			idc = 1605;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 0.39 * safezoneW + safezoneX;
			y = 0.445021 * safezoneH + safezoneY;
			w = 0.2 * safezoneW;
			h = 0.0287388 * safezoneH;
		};
		class RscButton_1605: SAC_RscButton_2
		{
			idc = 1606;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 0.39 * safezoneW + safezoneX;
			y = 0.486255 * safezoneH + safezoneY;
			w = 0.2 * safezoneW;
			h = 0.0287388 * safezoneH;
		};
		class RscButton_1606: SAC_RscButton_2
		{
			idc = 1607;
			text = ""; //--- ToDo: Localize;
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 0.39 * safezoneW + safezoneX;
			y = 0.527489 * safezoneH + safezoneY;
			w = 0.2 * safezoneW;
			h = 0.0287388 * safezoneH;
		};
		class RscButton_1607: SAC_RscButton_2
		{
			idc = 1608;
			text = "";
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 0.39 * safezoneW + safezoneX;
			y = 0.568723 * safezoneH + safezoneY;
			w = 0.2 * safezoneW;
			h = 0.0287388 * safezoneH;
		};
		class RscButton_1608: SAC_RscButton_2
		{
			idc = 1609;
			text = "";
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 0.39 * safezoneW + safezoneX;
			y = 0.609957 * safezoneH + safezoneY;
			w = 0.2 * safezoneW;
			h = 0.0287388 * safezoneH;
		};
		class RscButton_1609: SAC_RscButton_2
		{
			idc = 1610;
			text = "";
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 0.39 * safezoneW + safezoneX;
			y = 0.651191 * safezoneH + safezoneY;
			w = 0.2 * safezoneW;
			h = 0.0287388 * safezoneH;
		};
		class RscButton_1610: SAC_RscButton_2
		{
			idc = 1611;
			text = "";
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 0.39 * safezoneW + safezoneX;
			y = 0.692425 * safezoneH + safezoneY;
			w = 0.2 * safezoneW;
			h = 0.0287388 * safezoneH;
		};
		class RscButton_1611: SAC_RscButton_2
		{
			idc = 1612;
			text = "";
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 0.39 * safezoneW + safezoneX;
			y = 0.733659 * safezoneH + safezoneY;
			w = 0.2 * safezoneW;
			h = 0.0287388 * safezoneH;
		};
		class RscButton_1612: SAC_RscButton_2
		{
			idc = 1613;
			text = "";
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 0.39 * safezoneW + safezoneX;
			y = 0.774893 * safezoneH + safezoneY;
			w = 0.2 * safezoneW;
			h = 0.0287388 * safezoneH;
		};
		class RscButton_1613: SAC_RscButton_2
		{
			idc = 1614;
			text = "";
			onButtonClick = "SAC_user_input = ctrlText (_this select 0);((ctrlParent (_this select 0)) closeDisplay 3000);";
			x = 0.39 * safezoneW + safezoneX;
			y = 0.816127 * safezoneH + safezoneY;
			w = 0.2 * safezoneW;
			h = 0.0287388 * safezoneH;
		};
	};
};
