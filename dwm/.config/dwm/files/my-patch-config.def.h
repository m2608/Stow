--- config.def.h.orig	2023-02-15 23:30:17.080087009 +0300
+++ config.def.h	2023-02-15 23:20:16.234871887 +0300
@@ -5,17 +5,34 @@
 static const unsigned int snap      = 32;       /* snap pixel */
 static const int showbar            = 1;        /* 0 means no bar */
 static const int topbar             = 1;        /* 0 means bottom bar */
-static const char *fonts[]          = { "monospace:size=10" };
-static const char dmenufont[]       = "monospace:size=10";
-static const char col_gray1[]       = "#222222";
-static const char col_gray2[]       = "#444444";
-static const char col_gray3[]       = "#bbbbbb";
-static const char col_gray4[]       = "#eeeeee";
-static const char col_cyan[]        = "#005577";
+static const unsigned int systraypinning = 0;   /* 0: sloppy systray follows selected monitor, >0: pin systray to monitor X */
+static const unsigned int systrayonleft = 0;   	/* 0: systray in the right corner, >0: systray on left of status text */
+static const unsigned int systrayspacing = 2;   /* systray spacing */
+static const int systraypinningfailfirst = 1;   /* 1: if pinning fails, display systray on the first monitor, False: display systray on the last monitor*/
+static const int showsystray        = 1;     /* 0 means no systray */
+static const char dmenufont[]       = "xos4 Terminus:size=13";
+static const char *fonts[]          = { dmenufont };
+static const char col_norm_fg[]     = "#bbbbbb";
+static const char col_norm_bg[]     = "#222222";
+static const char col_norm_bord[]   = "#444444";
+static const char col_sel_fg[]      = "#f0f0f0";
+static const char col_sel_bg[]      = "#555555";
+static const char col_sel_bord[]    = "#555555";
 static const char *colors[][3]      = {
 	/*               fg         bg         border   */
-	[SchemeNorm] = { col_gray3, col_gray1, col_gray2 },
-	[SchemeSel]  = { col_gray4, col_cyan,  col_cyan  },
+	[SchemeNorm] = { col_norm_fg, col_norm_bg, col_norm_bord },
+	[SchemeSel]  = { col_sel_fg,  col_sel_bg,  col_sel_bord  }
+};
+
+typedef struct {
+	const char *name;
+	const void *cmd;
+} Sp;
+
+const char *spcmd1[] = {"st", "-n", "spterm", "-g", "120x34", NULL };
+static Sp scratchpads[] = {
+	/* name          cmd  */
+	{"spterm",      spcmd1}
 };
 
 /* tagging */
@@ -27,8 +44,8 @@
 	 *	WM_NAME(STRING) = title
 	 */
 	/* class      instance    title       tags mask     isfloating   monitor */
-	{ "Gimp",     NULL,       NULL,       0,            1,           -1 },
-	{ "Firefox",  NULL,       NULL,       1 << 8,       0,           -1 },
+	// Окна с тегом "скратчпад". Всплывает в центре экрана.
+	{ NULL,		    "spterm",   NULL,		              SPTAG(0),                 1,           -1 },
 };
 
 /* layout(s) */
@@ -45,7 +62,7 @@
 };
 
 /* key definitions */
-#define MODKEY Mod1Mask
+#define MODKEY Mod4Mask
 #define TAGKEYS(KEY,TAG) \
 	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
 	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
@@ -56,8 +73,8 @@
 #define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }
 
 /* commands */
-static const char *dmenucmd[] = { "dmenu_run", "-fn", dmenufont, "-nb", col_gray1, "-nf", col_gray3, "-sb", col_cyan, "-sf", col_gray4, NULL };
-static const char *termcmd[]  = { "st", NULL };
+static const char *dmenucmd[] = { "dmenu_run", "-fn", dmenufont, "-nb", col_norm_bg, "-nf", col_norm_fg, "-sb", col_sel_bg, "-sf", col_sel_fg, NULL };
+static const char *termcmd[]  = { "st", "-e", "tmux", NULL };
 
 static const Key keys[] = {
 	/* modifier                     key        function        argument */
@@ -84,6 +101,9 @@
 	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },
 	{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
 	{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
+	{ MODKEY,                       XK_u,      shiftview,      { -1 } },
+	{ MODKEY,                       XK_i,      shiftview,      { +1 } },
+	{ MODKEY,            		    XK_n,  	   togglescratch,  {.ui = 0 } },
 	TAGKEYS(                        XK_1,                      0)
 	TAGKEYS(                        XK_2,                      1)
 	TAGKEYS(                        XK_3,                      2)
