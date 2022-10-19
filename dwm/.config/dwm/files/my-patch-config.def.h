--- config.def.h.orig	2022-01-07 14:42:18.000000000 +0300
+++ config.def.h	2022-09-02 16:52:50.218868000 +0300
@@ -3,21 +3,41 @@
 /* appearance */
 static const unsigned int borderpx  = 1;        /* border pixel of windows */
 static const unsigned int snap      = 32;       /* snap pixel */
+static const unsigned int systraypinning = 0;   /* 0: sloppy systray follows selected monitor, >0: pin systray to monitor X */
+static const unsigned int systrayonleft = 0;   	/* 0: systray in the right corner, >0: systray on left of status text */
+static const unsigned int systrayspacing = 2;   /* systray spacing */
+static const int systraypinningfailfirst = 1;   /* 1: if pinning fails, display systray on the first monitor, False: display systray on the last monitor*/
+static const int showsystray        = 1;     /* 0 means no systray */
 static const int showbar            = 1;        /* 0 means no bar */
 static const int topbar             = 1;        /* 0 means bottom bar */
-static const char *fonts[]          = { "monospace:size=10" };
-static const char dmenufont[]       = "monospace:size=10";
-static const char col_gray1[]       = "#222222";
-static const char col_gray2[]       = "#444444";
-static const char col_gray3[]       = "#bbbbbb";
-static const char col_gray4[]       = "#eeeeee";
-static const char col_cyan[]        = "#005577";
+//static const char dmenufont[]       = "CozetteVector:size=14";
+static const char dmenufont[]       = "xos4 Terminus:size=13";
+static const char *fonts[]          = { dmenufont };
+
+static const char col_norm_fg[]     = "#bbbbbb";
+static const char col_norm_bg[]     = "#222222";
+static const char col_norm_bord[]   = "#444444";
+static const char col_sel_fg[]      = "#f0f0f0";
+static const char col_sel_bg[]      = "#555555";
+static const char col_sel_bord[]    = "#555555";
+
 static const char *colors[][3]      = {
-	/*               fg         bg         border   */
-	[SchemeNorm] = { col_gray3, col_gray1, col_gray2 },
-	[SchemeSel]  = { col_gray4, col_cyan,  col_cyan  },
+	/*               fg           bg           border   */
+	[SchemeNorm] = { col_norm_fg, col_norm_bg, col_norm_bord },
+	[SchemeSel]  = { col_sel_fg,  col_sel_bg,  col_sel_bord  }
 };
 
+typedef struct {
+	const char *name;
+	const void *cmd;
+} Sp;
+
+const char *spcmd1[] = {"st", "-n", "spterm", "-g", "120x34", NULL };
+static Sp scratchpads[] = {
+	/* name          cmd  */
+	{"spterm",      spcmd1}
+};
+
 /* tagging */
 static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };
 
@@ -26,9 +46,17 @@
 	 *	WM_CLASS(STRING) = instance, class
 	 *	WM_NAME(STRING) = title
 	 */
-	/* class      instance    title       tags mask     isfloating   monitor */
-	{ "Gimp",     NULL,       NULL,       0,            1,           -1 },
-	{ "Firefox",  NULL,       NULL,       1 << 8,       0,           -1 },
+	/* class      instance    title                     tags mask                 isfloating   monitor */
+	{ "Gimp",       NULL,       NULL,                     0,                        1,           -1 },
+	{ "xfreerdp",   NULL,       NULL,                     1 << 1,                   0,           -1 },
+	{ "Firefox",    NULL,       NULL,                     1 << 2,                   0,           -1 },
+    // Делаем "плавающим" окно "картинка в картинке" и показываем его на всех рабочих столах.
+    // Правила применяются по порядку, поэтому это правило будет применено после предыдущего правила для
+    // класса "Firefox". Окну будут навешены все таги, кроме тагов "скретчпад" окна.
+    { "Firefox",    NULL,       "Picture-in-Picture",     (1 << LENGTH(tags))-1,    1,           -1 },
+	{ "VirtualBox", NULL,       NULL,                     1 << 3,                   0,           -1 },
+	// Окна с тегом "скратчпад". Всплывает в центре экрана.
+	{ NULL,		    "spterm",   NULL,		              SPTAG(0),                 1,           -1 },
 };
 
 /* layout(s) */
@@ -45,7 +73,7 @@
 };
 
 /* key definitions */
-#define MODKEY Mod1Mask
+#define MODKEY Mod4Mask
 #define TAGKEYS(KEY,TAG) \
 	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
 	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
@@ -57,8 +85,8 @@
 
 /* commands */
 static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
-static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", col_gray1, "-nf", col_gray3, "-sb", col_cyan, "-sf", col_gray4, NULL };
-static const char *termcmd[]  = { "st", NULL };
+static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", col_norm_bg, "-nf", col_norm_fg, "-sb", col_sel_bg, "-sf", col_sel_fg, NULL };
+static const char *termcmd[]  = { "st", "-e", "tmux", NULL };
 
 static Key keys[] = {
 	/* modifier                     key        function        argument */
@@ -85,6 +113,9 @@
 	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },
 	{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
 	{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
+	{ MODKEY,                       XK_u,      shiftview,      { -1 } },
+	{ MODKEY,                       XK_i,      shiftview,      { +1 } },
+	{ MODKEY,            		    XK_n,  	   togglescratch,  {.ui = 0 } },
 	TAGKEYS(                        XK_1,                      0)
 	TAGKEYS(                        XK_2,                      1)
 	TAGKEYS(                        XK_3,                      2)
