--- x.c.orig	2022-01-07 14:41:35.000000000 +0300
+++ x.c	2022-07-06 00:27:27.676740000 +0300
@@ -14,6 +14,7 @@
 #include <X11/keysym.h>
 #include <X11/Xft/Xft.h>
 #include <X11/XKBlib.h>
+#include <X11/Xresource.h>
 
 char *argv0;
 #include "arg.h"
@@ -81,6 +82,7 @@
 typedef struct {
 	int tw, th; /* tty width and height */
 	int w, h; /* window width and height */
+	int hborderpx, vborderpx;
 	int ch; /* char height */
 	int cw; /* char width  */
 	int mode; /* window state/mode flags */
@@ -253,6 +255,7 @@
 static char *opt_title = NULL;
 
 static int oldbutton = 3; /* button event on startup: 3 = release */
+static int cursorblinks = 0;
 
 void
 clipcopy(const Arg *dummy)
@@ -331,7 +334,7 @@
 int
 evcol(XEvent *e)
 {
-	int x = e->xbutton.x - borderpx;
+	int x = e->xbutton.x - win.hborderpx;
 	LIMIT(x, 0, win.tw - 1);
 	return x / win.cw;
 }
@@ -339,7 +342,7 @@
 int
 evrow(XEvent *e)
 {
-	int y = e->xbutton.y - borderpx;
+	int y = e->xbutton.y - win.vborderpx;
 	LIMIT(y, 0, win.th - 1);
 	return y / win.ch;
 }
@@ -723,6 +726,9 @@
 	col = MAX(1, col);
 	row = MAX(1, row);
 
+	win.hborderpx = (win.w - col * win.cw) / 2;
+	win.vborderpx = (win.h - row * win.ch) / 2;
+
 	tresize(col, row);
 	xresize(col, row);
 	ttyresize(win.tw, win.th);
@@ -853,8 +859,8 @@
 	sizeh->flags = PSize | PResizeInc | PBaseSize | PMinSize;
 	sizeh->height = win.h;
 	sizeh->width = win.w;
-	sizeh->height_inc = win.ch;
-	sizeh->width_inc = win.cw;
+	sizeh->height_inc = 1;
+	sizeh->width_inc = 1;
 	sizeh->base_height = 2 * borderpx;
 	sizeh->base_width = 2 * borderpx;
 	sizeh->min_height = win.ch + 2 * borderpx;
@@ -1136,8 +1142,8 @@
 	xloadcols();
 
 	/* adjust fixed window geometry */
-	win.w = 2 * borderpx + cols * win.cw;
-	win.h = 2 * borderpx + rows * win.ch;
+	win.w = 2 * win.hborderpx + 2 * borderpx + cols * win.cw;
+	win.h = 2 * win.vborderpx + 2 * borderpx + rows * win.ch;
 	if (xw.gm & XNegative)
 		xw.l += DisplayWidth(xw.dpy, xw.scr) - win.w - 2;
 	if (xw.gm & YNegative)
@@ -1226,7 +1232,7 @@
 int
 xmakeglyphfontspecs(XftGlyphFontSpec *specs, const Glyph *glyphs, int len, int x, int y)
 {
-	float winx = borderpx + x * win.cw, winy = borderpx + y * win.ch, xp, yp;
+	float winx = win.hborderpx + x * win.cw, winy = win.vborderpx + y * win.ch, xp, yp;
 	ushort mode, prevmode = USHRT_MAX;
 	Font *font = &dc.font;
 	int frcflags = FRC_NORMAL;
@@ -1359,7 +1365,7 @@
 xdrawglyphfontspecs(const XftGlyphFontSpec *specs, Glyph base, int len, int x, int y)
 {
 	int charlen = len * ((base.mode & ATTR_WIDE) ? 2 : 1);
-	int winx = borderpx + x * win.cw, winy = borderpx + y * win.ch,
+	int winx = win.hborderpx + x * win.cw, winy = win.vborderpx + y * win.ch,
 	    width = charlen * win.cw;
 	Color *fg, *bg, *temp, revfg, revbg, truefg, truebg;
 	XRenderColor colfg, colbg;
@@ -1449,17 +1455,17 @@
 
 	/* Intelligent cleaning up of the borders. */
 	if (x == 0) {
-		xclear(0, (y == 0)? 0 : winy, borderpx,
+		xclear(0, (y == 0)? 0 : winy, win.vborderpx,
 			winy + win.ch +
-			((winy + win.ch >= borderpx + win.th)? win.h : 0));
+			((winy + win.ch >= win.vborderpx + win.th)? win.h : 0));
 	}
-	if (winx + width >= borderpx + win.tw) {
+	if (winx + width >= win.hborderpx + win.tw) {
 		xclear(winx + width, (y == 0)? 0 : winy, win.w,
-			((winy + win.ch >= borderpx + win.th)? win.h : (winy + win.ch)));
+			((winy + win.ch >= win.vborderpx + win.th)? win.h : (winy + win.ch)));
 	}
 	if (y == 0)
-		xclear(winx, 0, winx + width, borderpx);
-	if (winy + win.ch >= borderpx + win.th)
+		xclear(winx, 0, winx + width, win.vborderpx);
+	if (winy + win.ch >= win.vborderpx + win.th)
 		xclear(winx, winy + win.ch, winx + width, win.h);
 
 	/* Clean up the region we want to draw to. */
@@ -1541,47 +1547,61 @@
 
 	/* draw the new one */
 	if (IS_SET(MODE_FOCUSED)) {
-		switch (win.cursor) {
-		case 7: /* st extension */
-			g.u = 0x2603; /* snowman (U+2603) */
-			/* FALLTHROUGH */
-		case 0: /* Blinking Block */
-		case 1: /* Blinking Block (Default) */
-		case 2: /* Steady Block */
-			xdrawglyph(g, cx, cy);
-			break;
-		case 3: /* Blinking Underline */
-		case 4: /* Steady Underline */
-			XftDrawRect(xw.draw, &drawcol,
-					borderpx + cx * win.cw,
-					borderpx + (cy + 1) * win.ch - \
-						cursorthickness,
-					win.cw, cursorthickness);
-			break;
-		case 5: /* Blinking bar */
-		case 6: /* Steady bar */
-			XftDrawRect(xw.draw, &drawcol,
-					borderpx + cx * win.cw,
-					borderpx + cy * win.ch,
-					cursorthickness, win.ch);
-			break;
-		}
+        switch (win.cursor) {
+            case 0: /* Blinking block */
+            case 1: /* Blinking block (default) */
+                if (IS_SET(MODE_BLINK))
+                    break;
+                /* FALLTHROUGH */
+            case 2: /* Steady Block */
+                xdrawglyph(g, cx, cy);
+                break;
+            case 3: /* Blinking underline */
+                if (IS_SET(MODE_BLINK))
+                    break;
+                /* FALLTHROUGH */
+            case 4: /* Steady underline */
+                XftDrawRect(xw.draw, &drawcol,
+                        win.hborderpx + cx * win.cw,
+                        win.vborderpx + (cy + 1) * win.ch - \
+                        cursorthickness,
+                        win.cw, cursorthickness);
+                break;
+            case 5: /* Blinking bar */
+                if (IS_SET(MODE_BLINK))
+                    break;
+                /* FALLTHROUGH */
+            case 6: /* Steady bar */
+                XftDrawRect(xw.draw, &drawcol,
+                        win.hborderpx + cx * win.cw,
+                        win.vborderpx + cy * win.ch,
+                        cursorthickness, win.ch);
+                break;
+            case 7: /* Blinking st cursor */
+                if (IS_SET(MODE_BLINK))
+                    break;
+                /* FALLTHROUGH */
+            case 8: /* Steady st cursor */
+                g.u = stcursor;
+                xdrawglyph(g, cx, cy);
+                break;
+        }
 	} else {
 		XftDrawRect(xw.draw, &drawcol,
-				borderpx + cx * win.cw,
-				borderpx + cy * win.ch,
+				win.hborderpx + cx * win.cw,
+				win.vborderpx + cy * win.ch,
 				win.cw - 1, 1);
 		XftDrawRect(xw.draw, &drawcol,
-				borderpx + cx * win.cw,
-				borderpx + cy * win.ch,
+				win.hborderpx + cx * win.cw,
+				win.vborderpx + cy * win.ch,
 				1, win.ch - 1);
 		XftDrawRect(xw.draw, &drawcol,
-				borderpx + (cx + 1) * win.cw - 1,
-				borderpx + cy * win.ch,
+				win.hborderpx + (cx + 1) * win.cw - 1,
+				win.vborderpx + cy * win.ch,
 				1, win.ch - 1);
 		XftDrawRect(xw.draw, &drawcol,
-				borderpx + cx * win.cw,
-				borderpx + (cy + 1) * win.ch - 1,
+				win.hborderpx + cx * win.cw,
+				win.vborderpx + (cy + 1) * win.ch - 1,
 				win.cw, 1);
 	}
 }
@@ -1721,9 +1741,12 @@
 int
 xsetcursor(int cursor)
 {
-	if (!BETWEEN(cursor, 0, 7)) /* 7: st extension */
+	if (!BETWEEN(cursor, 0, 8)) /* 7-8: st extensions */
 		return 1;
 	win.cursor = cursor;
+	cursorblinks = win.cursor == 0 || win.cursor == 1 ||
+	               win.cursor == 3 || win.cursor == 5 ||
+	               win.cursor == 7;
 	return 0;
 }
 
@@ -1967,6 +1990,10 @@
 		if (FD_ISSET(ttyfd, &rfd) || xev) {
 			if (!drawing) {
 				trigger = now;
+				if (IS_SET(MODE_BLINK)) {
+					win.mode ^= MODE_BLINK;
+				}
+				lastblink = now;
 				drawing = 1;
 			}
 			timeout = (maxlatency - TIMEDIFF(now, trigger)) \
@@ -1977,7 +2004,7 @@
 
 		/* idle detected or maxlatency exhausted -> draw */
 		timeout = -1;
-		if (blinktimeout && tattrset(ATTR_BLINK)) {
+		if (blinktimeout && (cursorblinks || tattrset(ATTR_BLINK))) {
 			timeout = blinktimeout - TIMEDIFF(now, lastblink);
 			if (timeout <= 0) {
 				if (-timeout > blinktimeout) /* start visible */
@@ -1995,7 +2022,81 @@
 	}
 }
 
+#define XRESOURCE_LOAD_META(NAME)					\
+	if(!XrmGetResource(xrdb, "st." NAME, "st." NAME, &type, &ret))	\
+		XrmGetResource(xrdb, "*." NAME, "*." NAME, &type, &ret); \
+	if (ret.addr != NULL && !strncmp("String", type, 64))
+
+#define XRESOURCE_LOAD_STRING(NAME, DST)	\
+	XRESOURCE_LOAD_META(NAME)		\
+		DST = ret.addr;
+
+#define XRESOURCE_LOAD_CHAR(NAME, DST)		\
+	XRESOURCE_LOAD_META(NAME)		\
+		DST = ret.addr[0];
+
+#define XRESOURCE_LOAD_INTEGER(NAME, DST)		\
+	XRESOURCE_LOAD_META(NAME)			\
+		DST = strtoul(ret.addr, NULL, 10);
+
+#define XRESOURCE_LOAD_FLOAT(NAME, DST)		\
+	XRESOURCE_LOAD_META(NAME)		\
+		DST = strtof(ret.addr, NULL);
+
 void
+xrdb_load(void)
+{
+	/* XXX */
+	char *xrm;
+	char *type;
+	XrmDatabase xrdb;
+	XrmValue ret;
+	Display *dpy;
+
+	if(!(dpy = XOpenDisplay(NULL)))
+		die("Can't open display\n");
+
+	XrmInitialize();
+	xrm = XResourceManagerString(dpy);
+
+	if (xrm != NULL) {
+		xrdb = XrmGetStringDatabase(xrm);
+		XRESOURCE_LOAD_STRING("font", font);
+		XRESOURCE_LOAD_STRING("termname", termname);
+
+		XRESOURCE_LOAD_INTEGER("blinktimeout", blinktimeout);
+		XRESOURCE_LOAD_INTEGER("bellvolume", bellvolume);
+		XRESOURCE_LOAD_INTEGER("borderpx", borderpx);
+		XRESOURCE_LOAD_INTEGER("cursorshape", cursorshape);
+
+		XRESOURCE_LOAD_FLOAT("cwscale", cwscale);
+		XRESOURCE_LOAD_FLOAT("chscale", chscale);
+	}
+	XFlush(dpy);
+}
+
+void
+reload(int sig)
+{
+	xrdb_load();
+
+	/* fonts */
+	xunloadfonts();
+	xloadfonts(font, 0);
+
+	/* pretend the window just got resized */
+	cresize(win.w, win.h);
+
+	redraw();
+
+	/* triggers re-render if we're visible. */
+	ttywrite("\033[O", 3, 1);
+
+	signal(SIGUSR1, reload);
+}
+
+
+void
 usage(void)
 {
 	die("usage: %s [-aiv] [-c class] [-f font] [-g geometry]"
@@ -2068,6 +2169,8 @@
 
 	setlocale(LC_CTYPE, "");
 	XSetLocaleModifiers("");
+	xrdb_load();
+	signal(SIGUSR1, reload);
 	cols = MAX(cols, 1);
 	rows = MAX(rows, 1);
 	tnew(cols, rows);
