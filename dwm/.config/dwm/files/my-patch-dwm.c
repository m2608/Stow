--- dwm.c.orig	2022-01-07 14:42:18.000000000 +0300
+++ dwm.c	2022-09-02 16:55:50.980579000 +0300
@@ -29,6 +29,7 @@
 #include <string.h>
 #include <unistd.h>
 #include <sys/types.h>
+#include <sys/stat.h>
 #include <sys/wait.h>
 #include <X11/cursorfont.h>
 #include <X11/keysym.h>
@@ -54,15 +55,36 @@
 #define MOUSEMASK               (BUTTONMASK|PointerMotionMask)
 #define WIDTH(X)                ((X)->w + 2 * (X)->bw)
 #define HEIGHT(X)               ((X)->h + 2 * (X)->bw)
-#define TAGMASK                 ((1 << LENGTH(tags)) - 1)
+#define NUMTAGS					(LENGTH(tags) + LENGTH(scratchpads))
+#define TAGMASK     			((1 << NUMTAGS) - 1)
+#define SPTAG(i) 				((1 << LENGTH(tags)) << (i))
+#define SPTAGMASK   			(((1 << LENGTH(scratchpads))-1) << LENGTH(tags))
 #define TEXTW(X)                (drw_fontset_getwidth(drw, (X)) + lrpad)
 
+#define SYSTEM_TRAY_REQUEST_DOCK    0
+
+/* XEMBED messages */
+#define XEMBED_EMBEDDED_NOTIFY      0
+#define XEMBED_WINDOW_ACTIVATE      1
+#define XEMBED_FOCUS_IN             4
+#define XEMBED_MODALITY_ON         10
+
+#define XEMBED_MAPPED              (1 << 0)
+#define XEMBED_WINDOW_ACTIVATE      1
+#define XEMBED_WINDOW_DEACTIVATE    2
+
+#define VERSION_MAJOR               0
+#define VERSION_MINOR               0
+#define XEMBED_EMBEDDED_VERSION (VERSION_MAJOR << 16) | VERSION_MINOR
+
 /* enums */
 enum { CurNormal, CurResize, CurMove, CurLast }; /* cursor */
 enum { SchemeNorm, SchemeSel }; /* color schemes */
 enum { NetSupported, NetWMName, NetWMState, NetWMCheck,
+       NetSystemTray, NetSystemTrayOP, NetSystemTrayOrientation, NetSystemTrayOrientationHorz,
        NetWMFullscreen, NetActiveWindow, NetWMWindowType,
        NetWMWindowTypeDialog, NetClientList, NetLast }; /* EWMH atoms */
+enum { Manager, Xembed, XembedInfo, XLast }; /* Xembed atoms */
 enum { WMProtocols, WMDelete, WMState, WMTakeFocus, WMLast }; /* default atoms */
 enum { ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle,
        ClkClientWin, ClkRootWin, ClkLast }; /* clicks */
@@ -141,6 +163,12 @@
 	int monitor;
 } Rule;
 
+typedef struct Systray   Systray;
+struct Systray {
+	Window win;
+	Client *icons;
+};
+
 /* function declarations */
 static void applyrules(Client *c);
 static int applysizehints(Client *c, int *x, int *y, int *w, int *h, int interact);
@@ -172,6 +200,7 @@
 static Atom getatomprop(Client *c, Atom prop);
 static int getrootptr(int *x, int *y);
 static long getstate(Window w);
+static unsigned int getsystraywidth();
 static int gettextprop(Window w, Atom atom, char *text, unsigned int size);
 static void grabbuttons(Client *c, int focused);
 static void grabkeys(void);
@@ -189,13 +218,18 @@
 static void propertynotify(XEvent *e);
 static void quit(const Arg *arg);
 static Monitor *recttomon(int x, int y, int w, int h);
+static void removesystrayicon(Client *i);
 static void resize(Client *c, int x, int y, int w, int h, int interact);
+static void resizebarwin(Monitor *m);
 static void resizeclient(Client *c, int x, int y, int w, int h);
 static void resizemouse(const Arg *arg);
+static void resizerequest(XEvent *e);
 static void restack(Monitor *m);
 static void run(void);
+static void runautostart(void);
+static void runautostop(void);
 static void scan(void);
-static int sendevent(Client *c, Atom proto);
+static int sendevent(Window w, Atom proto, int m, long d0, long d1, long d2, long d3, long d4);
 static void sendmon(Client *c, Monitor *m);
 static void setclientstate(Client *c, long state);
 static void setfocus(Client *c);
@@ -207,11 +241,13 @@
 static void showhide(Client *c);
 static void sigchld(int unused);
 static void spawn(const Arg *arg);
+static Monitor *systraytomon(Monitor *m);
 static void tag(const Arg *arg);
 static void tagmon(const Arg *arg);
 static void tile(Monitor *);
 static void togglebar(const Arg *arg);
 static void togglefloating(const Arg *arg);
+static void togglescratch(const Arg *arg);
 static void toggletag(const Arg *arg);
 static void toggleview(const Arg *arg);
 static void unfocus(Client *c, int setfocus);
@@ -224,19 +260,30 @@
 static void updatenumlockmask(void);
 static void updatesizehints(Client *c);
 static void updatestatus(void);
+static void updatesystray(void);
+static void updatesystrayicongeom(Client *i, int w, int h);
+static void updatesystrayiconstate(Client *i, XPropertyEvent *ev);
 static void updatetitle(Client *c);
 static void updatewindowtype(Client *c);
 static void updatewmhints(Client *c);
 static void view(const Arg *arg);
 static Client *wintoclient(Window w);
 static Monitor *wintomon(Window w);
+static Client *wintosystrayicon(Window w);
 static int xerror(Display *dpy, XErrorEvent *ee);
 static int xerrordummy(Display *dpy, XErrorEvent *ee);
 static int xerrorstart(Display *dpy, XErrorEvent *ee);
 static void zoom(const Arg *arg);
+static void shiftview(const Arg *arg);
 
 /* variables */
+static Systray *systray =  NULL;
+static const char autostartblocksh[] = "autostart_blocking.sh";
+static const char autostartsh[] = "autostart.sh";
+static const char autostop[] = "autostop.sh";
 static const char broken[] = "broken";
+static const char dwmdir[] = "dwm";
+static const char localshare[] = ".local/share";
 static char stext[256];
 static int screen;
 static int sw, sh;           /* X display screen geometry width, height */
@@ -258,9 +305,10 @@
 	[MapRequest] = maprequest,
 	[MotionNotify] = motionnotify,
 	[PropertyNotify] = propertynotify,
+	[ResizeRequest] = resizerequest,
 	[UnmapNotify] = unmapnotify
 };
-static Atom wmatom[WMLast], netatom[NetLast];
+static Atom wmatom[WMLast], netatom[NetLast], xatom[XLast];
 static int running = 1;
 static Cur *cursor[CurLast];
 static Clr **scheme;
@@ -300,6 +348,11 @@
 		{
 			c->isfloating = r->isfloating;
 			c->tags |= r->tags;
+			if ((r->tags & SPTAGMASK) && r->isfloating) {
+				c->x = c->mon->wx + (c->mon->ww / 2 - WIDTH(c) / 2);
+				c->y = c->mon->wy + (c->mon->wh / 2 - HEIGHT(c) / 2);
+			}
+
 			for (m = mons; m && m->num != r->monitor; m = m->next);
 			if (m)
 				c->mon = m;
@@ -440,7 +493,7 @@
 			arg.ui = 1 << i;
 		} else if (ev->x < x + blw)
 			click = ClkLtSymbol;
-		else if (ev->x > selmon->ww - (int)TEXTW(stext))
+		else if (ev->x > selmon->ww - (int)TEXTW(stext) - getsystraywidth())
 			click = ClkStatusText;
 		else
 			click = ClkWinTitle;
@@ -483,6 +536,11 @@
 	XUngrabKey(dpy, AnyKey, AnyModifier, root);
 	while (mons)
 		cleanupmon(mons);
+	if (showsystray) {
+		XUnmapWindow(dpy, systray->win);
+		XDestroyWindow(dpy, systray->win);
+		free(systray);
+	}
 	for (i = 0; i < CurLast; i++)
 		drw_cur_free(drw, cursor[i]);
 	for (i = 0; i < LENGTH(colors); i++)
@@ -513,9 +571,57 @@
 void
 clientmessage(XEvent *e)
 {
+	XWindowAttributes wa;
+	XSetWindowAttributes swa;
 	XClientMessageEvent *cme = &e->xclient;
 	Client *c = wintoclient(cme->window);
 
+	if (showsystray && cme->window == systray->win && cme->message_type == netatom[NetSystemTrayOP]) {
+		/* add systray icons */
+		if (cme->data.l[1] == SYSTEM_TRAY_REQUEST_DOCK) {
+			if (!(c = (Client *)calloc(1, sizeof(Client))))
+				die("fatal: could not malloc() %u bytes\n", sizeof(Client));
+			if (!(c->win = cme->data.l[2])) {
+				free(c);
+				return;
+			}
+			c->mon = selmon;
+			c->next = systray->icons;
+			systray->icons = c;
+			if (!XGetWindowAttributes(dpy, c->win, &wa)) {
+				/* use sane defaults */
+				wa.width = bh;
+				wa.height = bh;
+				wa.border_width = 0;
+			}
+			c->x = c->oldx = c->y = c->oldy = 0;
+			c->w = c->oldw = wa.width;
+			c->h = c->oldh = wa.height;
+			c->oldbw = wa.border_width;
+			c->bw = 0;
+			c->isfloating = True;
+			/* reuse tags field as mapped status */
+			c->tags = 1;
+			updatesizehints(c);
+			updatesystrayicongeom(c, wa.width, wa.height);
+			XAddToSaveSet(dpy, c->win);
+			XSelectInput(dpy, c->win, StructureNotifyMask | PropertyChangeMask | ResizeRedirectMask);
+			XReparentWindow(dpy, c->win, systray->win, 0, 0);
+			/* use parents background color */
+			swa.background_pixel  = scheme[SchemeNorm][ColBg].pixel;
+			XChangeWindowAttributes(dpy, c->win, CWBackPixel, &swa);
+			sendevent(c->win, netatom[Xembed], StructureNotifyMask, CurrentTime, XEMBED_EMBEDDED_NOTIFY, 0 , systray->win, XEMBED_EMBEDDED_VERSION);
+			/* FIXME not sure if I have to send these events, too */
+			sendevent(c->win, netatom[Xembed], StructureNotifyMask, CurrentTime, XEMBED_FOCUS_IN, 0 , systray->win, XEMBED_EMBEDDED_VERSION);
+			sendevent(c->win, netatom[Xembed], StructureNotifyMask, CurrentTime, XEMBED_WINDOW_ACTIVATE, 0 , systray->win, XEMBED_EMBEDDED_VERSION);
+			sendevent(c->win, netatom[Xembed], StructureNotifyMask, CurrentTime, XEMBED_MODALITY_ON, 0 , systray->win, XEMBED_EMBEDDED_VERSION);
+			XSync(dpy, False);
+			resizebarwin(selmon);
+			updatesystray();
+			setclientstate(c, NormalState);
+		}
+		return;
+	}
 	if (!c)
 		return;
 	if (cme->message_type == netatom[NetWMState]) {
@@ -568,7 +674,7 @@
 				for (c = m->clients; c; c = c->next)
 					if (c->isfullscreen)
 						resizeclient(c, m->mx, m->my, m->mw, m->mh);
-				XMoveResizeWindow(dpy, m->barwin, m->wx, m->by, m->ww, bh);
+				resizebarwin(m);
 			}
 			focus(NULL);
 			arrange(NULL);
@@ -653,6 +759,11 @@
 
 	if ((c = wintoclient(ev->window)))
 		unmanage(c, 1);
+	else if ((c = wintosystrayicon(ev->window))) {
+		removesystrayicon(c);
+		resizebarwin(selmon);
+		updatesystray();
+	}
 }
 
 void
@@ -696,7 +807,7 @@
 void
 drawbar(Monitor *m)
 {
-	int x, w, tw = 0;
+	int x, w, tw = 0, stw = 0;
 	int boxs = drw->fonts->h / 9;
 	int boxw = drw->fonts->h / 6 + 2;
 	unsigned int i, occ = 0, urg = 0;
@@ -705,13 +816,17 @@
 	if (!m->showbar)
 		return;
 
+	if(showsystray && m == systraytomon(m) && !systrayonleft)
+		stw = getsystraywidth();
+
 	/* draw status first so it can be overdrawn by tags later */
 	if (m == selmon) { /* status is only drawn on selected monitor */
 		drw_setscheme(drw, scheme[SchemeNorm]);
-		tw = TEXTW(stext) - lrpad + 2; /* 2px right padding */
-		drw_text(drw, m->ww - tw, 0, tw, bh, 0, stext, 0);
+		tw = TEXTW(stext) - lrpad / 2 + 2; /* 2px extra right padding */
+		drw_text(drw, m->ww - tw - stw, 0, tw, bh, lrpad / 2 - 2, stext, 0);
 	}
 
+	resizebarwin(m);
 	for (c = m->clients; c; c = c->next) {
 		occ |= c->tags;
 		if (c->isurgent)
@@ -732,7 +847,7 @@
 	drw_setscheme(drw, scheme[SchemeNorm]);
 	x = drw_text(drw, x, 0, w, bh, lrpad / 2, m->ltsymbol, 0);
 
-	if ((w = m->ww - tw - x) > bh) {
+	if ((w = m->ww - tw - stw - x) > bh) {
 		if (m->sel) {
 			drw_setscheme(drw, scheme[m == selmon ? SchemeSel : SchemeNorm]);
 			drw_text(drw, x, 0, w, bh, lrpad / 2, m->sel->name, 0);
@@ -743,7 +858,7 @@
 			drw_rect(drw, x, 0, w, bh, 1, 1);
 		}
 	}
-	drw_map(drw, m->barwin, 0, 0, m->ww, bh);
+	drw_map(drw, m->barwin, 0, 0, m->ww - stw, bh);
 }
 
 void
@@ -780,8 +895,11 @@
 	Monitor *m;
 	XExposeEvent *ev = &e->xexpose;
 
-	if (ev->count == 0 && (m = wintomon(ev->window)))
-		drawbar(m);
+	if (ev->count == 0 && (m = wintomon(ev->window))) {
+        drawbar(m);
+	    if (m == selmon)
+			updatesystray();
+	}
 }
 
 void
@@ -866,10 +984,17 @@
 	unsigned long dl;
 	unsigned char *p = NULL;
 	Atom da, atom = None;
+	/* FIXME getatomprop should return the number of items and a pointer to
+	 * the stored data instead of this workaround */
+	Atom req = XA_ATOM;
+	if (prop == xatom[XembedInfo])
+		req = xatom[XembedInfo];
 
-	if (XGetWindowProperty(dpy, c->win, prop, 0L, sizeof atom, False, XA_ATOM,
+	if (XGetWindowProperty(dpy, c->win, prop, 0L, sizeof atom, False, req,
 		&da, &di, &dl, &dl, &p) == Success && p) {
 		atom = *(Atom *)p;
+		if (da == xatom[XembedInfo] && dl == 2)
+			atom = ((Atom *)p)[1];
 		XFree(p);
 	}
 	return atom;
@@ -903,6 +1028,16 @@
 	return result;
 }
 
+unsigned int
+getsystraywidth()
+{
+	unsigned int w = 0;
+	Client *i;
+	if(showsystray)
+		for(i = systray->icons; i; w += i->w + systrayspacing, i = i->next) ;
+	return w ? w + systrayspacing : 1;
+}
+
 int
 gettextprop(Window w, Atom atom, char *text, unsigned int size)
 {
@@ -1007,7 +1142,7 @@
 {
 	if (!selmon->sel)
 		return;
-	if (!sendevent(selmon->sel, wmatom[WMDelete])) {
+	if (!sendevent(selmon->sel->win, wmatom[WMDelete], NoEventMask, wmatom[WMDelete], CurrentTime, 0 , 0, 0)) {
 		XGrabServer(dpy);
 		XSetErrorHandler(xerrordummy);
 		XSetCloseDownMode(dpy, DestroyAll);
@@ -1095,6 +1230,12 @@
 {
 	static XWindowAttributes wa;
 	XMapRequestEvent *ev = &e->xmaprequest;
+	Client *i;
+	if ((i = wintosystrayicon(ev->window))) {
+		sendevent(i->win, netatom[Xembed], StructureNotifyMask, CurrentTime, XEMBED_WINDOW_ACTIVATE, 0, systray->win, XEMBED_EMBEDDED_VERSION);
+		resizebarwin(selmon);
+		updatesystray();
+	}
 
 	if (!XGetWindowAttributes(dpy, ev->window, &wa))
 		return;
@@ -1219,6 +1360,17 @@
 	Window trans;
 	XPropertyEvent *ev = &e->xproperty;
 
+	if ((c = wintosystrayicon(ev->window))) {
+		if (ev->atom == XA_WM_NORMAL_HINTS) {
+			updatesizehints(c);
+			updatesystrayicongeom(c, c->w, c->h);
+		}
+		else
+			updatesystrayiconstate(c, ev);
+		resizebarwin(selmon);
+		updatesystray();
+	}
+
 	if ((ev->window == root) && (ev->atom == XA_WM_NAME))
 		updatestatus();
 	else if (ev->state == PropertyDelete)
@@ -1270,6 +1422,19 @@
 }
 
 void
+removesystrayicon(Client *i)
+{
+	Client **ii;
+
+	if (!showsystray || !i)
+		return;
+	for (ii = &systray->icons; *ii && *ii != i; ii = &(*ii)->next);
+	if (ii)
+		*ii = i->next;
+	free(i);
+}
+
+void
 resize(Client *c, int x, int y, int w, int h, int interact)
 {
 	if (applysizehints(c, &x, &y, &w, &h, interact))
@@ -1277,15 +1442,24 @@
 }
 
 void
+resizebarwin(Monitor *m) {
+	unsigned int w = m->ww;
+	if (showsystray && m == systraytomon(m) && !systrayonleft)
+		w -= getsystraywidth();
+	XMoveResizeWindow(dpy, m->barwin, m->wx, m->by, w, bh);
+}
+
+void
 resizeclient(Client *c, int x, int y, int w, int h)
 {
 	XWindowChanges wc;
 
-	c->oldx = c->x; c->x = wc.x = x;
-	c->oldy = c->y; c->y = wc.y = y;
-	c->oldw = c->w; c->w = wc.width = w;
-	c->oldh = c->h; c->h = wc.height = h;
+    c->oldx = c->x; c->x = wc.x = x;
+    c->oldy = c->y; c->y = wc.y = y;
+    c->oldw = c->w; c->w = wc.width = w;
+    c->oldh = c->h; c->h = wc.height = h;
 	wc.border_width = c->bw;
+
 	XConfigureWindow(dpy, c->win, CWX|CWY|CWWidth|CWHeight|CWBorderWidth, &wc);
 	configure(c);
 	XSync(dpy, False);
@@ -1349,6 +1523,19 @@
 }
 
 void
+resizerequest(XEvent *e)
+{
+	XResizeRequestEvent *ev = &e->xresizerequest;
+	Client *i;
+
+	if ((i = wintosystrayicon(ev->window))) {
+		updatesystrayicongeom(i, ev->width, ev->height);
+		resizebarwin(selmon);
+		updatesystray();
+	}
+}
+
+void
 restack(Monitor *m)
 {
 	Client *c;
@@ -1384,7 +1571,133 @@
 			handler[ev.type](&ev); /* call handler */
 }
 
+/*
+ * Определяет каталог, в котором хранятся скрипты автозапуска не текущей
+ * системе. Порядок приоритета таков:
+ * 1. $XDG_DATA_HOME/dwm
+ * 2. $HOME/local/share/dwm
+ * 3. $HOME/.dwm
+ * Возвращает ссылку на путь или NULL.
+ */
+char*
+get_dwm_script_dir(void) 
+{
+	char *home;
+	char *xdgdatahome;
+    char *pathpfx;
+	struct stat sb;
+
+	if ((home = getenv("HOME")) == NULL) {
+		/* this is almost impossible */
+		return NULL;
+    }
+
+	/* if $XDG_DATA_HOME is set and not empty, use $XDG_DATA_HOME/dwm,
+	 * otherwise use ~/.local/share/dwm as autostart script directory
+	 */
+	xdgdatahome = getenv("XDG_DATA_HOME");
+	if (xdgdatahome != NULL && *xdgdatahome != '\0') {
+		/* space for path segments, separators and nul */
+		pathpfx = ecalloc(1, strlen(xdgdatahome) + strlen(dwmdir) + 2);
+
+		if (sprintf(pathpfx, "%s/%s", xdgdatahome, dwmdir) <= 0) {
+			free(pathpfx);
+			return NULL;
+		}
+	} else {
+		/* space for path segments, separators and nul */
+        pathpfx = ecalloc(1, strlen(home) + strlen(localshare) + strlen(dwmdir) + 3);
+
+		if (sprintf(pathpfx, "%s/%s/%s", home, localshare, dwmdir) < 0) {
+			free(pathpfx);
+			return NULL;
+		}
+	}
+
+	/* check if the autostart script directory exists */
+	if (! (stat(pathpfx, &sb) == 0 && S_ISDIR(sb.st_mode))) {
+		/* the XDG conformant path does not exist or is no directory
+		 * so we try ~/.dwm instead
+		 */
+		char *pathpfx_new = realloc(pathpfx, strlen(home) + strlen(dwmdir) + 3);
+		if(pathpfx_new == NULL) {
+			free(pathpfx);
+			return NULL;
+		}
+		pathpfx = pathpfx_new;
+
+		if (sprintf(pathpfx, "%s/.%s", home, dwmdir) <= 0) {
+			free(pathpfx);
+			return NULL;
+		}
+	}
+
+    return pathpfx;
+}
+
 void
+runautostart(void)
+{
+	char *pathpfx;
+	char *path;
+
+    pathpfx = get_dwm_script_dir();
+    if (pathpfx == NULL) {
+        return;
+    }
+
+	/* try the blocking script first */
+	path = ecalloc(1, strlen(pathpfx) + strlen(autostartblocksh) + 2);
+	if (sprintf(path, "%s/%s", pathpfx, autostartblocksh) <= 0) {
+		free(path);
+		free(pathpfx);
+	}
+
+	if (access(path, X_OK) == 0) {
+		system(path);
+    }
+
+	/* now the non-blocking script */
+	if (sprintf(path, "%s/%s", pathpfx, autostartsh) <= 0) {
+		free(path);
+		free(pathpfx);
+	}
+
+	if (access(path, X_OK) == 0) {
+		system(strcat(path, " &"));
+    }
+
+	free(pathpfx);
+	free(path);
+}
+
+
+void
+runautostop(void)
+{
+	char *pathpfx;
+	char *path;
+
+    pathpfx = get_dwm_script_dir();
+    if(pathpfx == NULL) {
+        return;
+    }
+
+	path = ecalloc(1, strlen(pathpfx) + strlen(autostop) + 2);
+	if (sprintf(path, "%s/%s", pathpfx, autostop) <= 0) {
+		free(path);
+		free(pathpfx);
+	}
+
+	if (access(path, X_OK) == 0) {
+		system(path);
+    }
+
+	free(pathpfx);
+	free(path);
+}
+
+void
 scan(void)
 {
 	unsigned int i, num;
@@ -1437,26 +1750,36 @@
 }
 
 int
-sendevent(Client *c, Atom proto)
+sendevent(Window w, Atom proto, int mask, long d0, long d1, long d2, long d3, long d4)
 {
 	int n;
-	Atom *protocols;
+	Atom *protocols, mt;
 	int exists = 0;
 	XEvent ev;
 
-	if (XGetWMProtocols(dpy, c->win, &protocols, &n)) {
-		while (!exists && n--)
-			exists = protocols[n] == proto;
-		XFree(protocols);
+	if (proto == wmatom[WMTakeFocus] || proto == wmatom[WMDelete]) {
+		mt = wmatom[WMProtocols];
+		if (XGetWMProtocols(dpy, w, &protocols, &n)) {
+			while (!exists && n--)
+				exists = protocols[n] == proto;
+			XFree(protocols);
+		}
 	}
+	else {
+		exists = True;
+		mt = proto;
+	}
 	if (exists) {
 		ev.type = ClientMessage;
-		ev.xclient.window = c->win;
-		ev.xclient.message_type = wmatom[WMProtocols];
+		ev.xclient.window = w;
+		ev.xclient.message_type = mt;
 		ev.xclient.format = 32;
-		ev.xclient.data.l[0] = proto;
-		ev.xclient.data.l[1] = CurrentTime;
-		XSendEvent(dpy, c->win, False, NoEventMask, &ev);
+		ev.xclient.data.l[0] = d0;
+		ev.xclient.data.l[1] = d1;
+		ev.xclient.data.l[2] = d2;
+		ev.xclient.data.l[3] = d3;
+		ev.xclient.data.l[4] = d4;
+		XSendEvent(dpy, w, False, mask, &ev);
 	}
 	return exists;
 }
@@ -1470,7 +1793,7 @@
 			XA_WINDOW, 32, PropModeReplace,
 			(unsigned char *) &(c->win), 1);
 	}
-	sendevent(c, wmatom[WMTakeFocus]);
+	sendevent(c->win, wmatom[WMTakeFocus], NoEventMask, wmatom[WMTakeFocus], CurrentTime, 0, 0, 0);
 }
 
 void
@@ -1559,6 +1882,10 @@
 	wmatom[WMTakeFocus] = XInternAtom(dpy, "WM_TAKE_FOCUS", False);
 	netatom[NetActiveWindow] = XInternAtom(dpy, "_NET_ACTIVE_WINDOW", False);
 	netatom[NetSupported] = XInternAtom(dpy, "_NET_SUPPORTED", False);
+	netatom[NetSystemTray] = XInternAtom(dpy, "_NET_SYSTEM_TRAY_S0", False);
+	netatom[NetSystemTrayOP] = XInternAtom(dpy, "_NET_SYSTEM_TRAY_OPCODE", False);
+	netatom[NetSystemTrayOrientation] = XInternAtom(dpy, "_NET_SYSTEM_TRAY_ORIENTATION", False);
+	netatom[NetSystemTrayOrientationHorz] = XInternAtom(dpy, "_NET_SYSTEM_TRAY_ORIENTATION_HORZ", False);
 	netatom[NetWMName] = XInternAtom(dpy, "_NET_WM_NAME", False);
 	netatom[NetWMState] = XInternAtom(dpy, "_NET_WM_STATE", False);
 	netatom[NetWMCheck] = XInternAtom(dpy, "_NET_SUPPORTING_WM_CHECK", False);
@@ -1566,6 +1893,9 @@
 	netatom[NetWMWindowType] = XInternAtom(dpy, "_NET_WM_WINDOW_TYPE", False);
 	netatom[NetWMWindowTypeDialog] = XInternAtom(dpy, "_NET_WM_WINDOW_TYPE_DIALOG", False);
 	netatom[NetClientList] = XInternAtom(dpy, "_NET_CLIENT_LIST", False);
+	xatom[Manager] = XInternAtom(dpy, "MANAGER", False);
+	xatom[Xembed] = XInternAtom(dpy, "_XEMBED", False);
+	xatom[XembedInfo] = XInternAtom(dpy, "_XEMBED_INFO", False);
 	/* init cursors */
 	cursor[CurNormal] = drw_cur_create(drw, XC_left_ptr);
 	cursor[CurResize] = drw_cur_create(drw, XC_sizing);
@@ -1574,6 +1904,8 @@
 	scheme = ecalloc(LENGTH(colors), sizeof(Clr *));
 	for (i = 0; i < LENGTH(colors); i++)
 		scheme[i] = drw_scm_create(drw, colors[i], 3);
+	/* init system tray */
+	updatesystray();
 	/* init bars */
 	updatebars();
 	updatestatus();
@@ -1620,6 +1952,10 @@
 	if (!c)
 		return;
 	if (ISVISIBLE(c)) {
+		if ((c->tags & SPTAGMASK) && c->isfloating) {
+			c->x = c->mon->wx + (c->mon->ww / 2 - WIDTH(c) / 2);
+			c->y = c->mon->wy + (c->mon->wh / 2 - HEIGHT(c) / 2);
+		}
 		/* show clients top down */
 		XMoveWindow(dpy, c->win, c->x, c->y);
 		if ((!c->mon->lt[c->mon->sellt]->arrange || c->isfloating) && !c->isfullscreen)
@@ -1707,7 +2043,18 @@
 {
 	selmon->showbar = !selmon->showbar;
 	updatebarpos(selmon);
-	XMoveResizeWindow(dpy, selmon->barwin, selmon->wx, selmon->by, selmon->ww, bh);
+	resizebarwin(selmon);
+	if (showsystray) {
+		XWindowChanges wc;
+		if (!selmon->showbar)
+			wc.y = -bh;
+		else if (selmon->showbar) {
+			wc.y = 0;
+			if (!selmon->topbar)
+				wc.y = selmon->mh - bh;
+		}
+		XConfigureWindow(dpy, systray->win, CWY, &wc);
+	}
 	arrange(selmon);
 }
 
@@ -1726,6 +2073,33 @@
 }
 
 void
+togglescratch(const Arg *arg)
+{
+	Client *c;
+	unsigned int found = 0;
+	unsigned int scratchtag = SPTAG(arg->ui);
+	Arg sparg = {.v = scratchpads[arg->ui].cmd};
+
+	for (c = selmon->clients; c && !(found = c->tags & scratchtag); c = c->next);
+	if (found) {
+		unsigned int newtagset = selmon->tagset[selmon->seltags] ^ scratchtag;
+		if (newtagset) {
+			selmon->tagset[selmon->seltags] = newtagset;
+			focus(NULL);
+			arrange(selmon);
+		}
+		if (ISVISIBLE(c)) {
+			focus(c);
+			restack(selmon);
+		}
+	} else {
+		selmon->tagset[selmon->seltags] |= scratchtag;
+		spawn(&sparg);
+	}
+}
+
+
+void
 toggletag(const Arg *arg)
 {
 	unsigned int newtags;
@@ -1802,11 +2176,18 @@
 		else
 			unmanage(c, 0);
 	}
+	else if ((c = wintosystrayicon(ev->window))) {
+		/* KLUDGE! sometimes icons occasionally unmap their windows, but do
+		 * _not_ destroy them. We map those windows back */
+		XMapRaised(dpy, c->win);
+		updatesystray();
+	}
 }
 
 void
 updatebars(void)
 {
+	unsigned int w;
 	Monitor *m;
 	XSetWindowAttributes wa = {
 		.override_redirect = True,
@@ -1817,10 +2198,15 @@
 	for (m = mons; m; m = m->next) {
 		if (m->barwin)
 			continue;
-		m->barwin = XCreateWindow(dpy, root, m->wx, m->by, m->ww, bh, 0, DefaultDepth(dpy, screen),
+		w = m->ww;
+		if (showsystray && m == systraytomon(m))
+			w -= getsystraywidth();
+		m->barwin = XCreateWindow(dpy, root, m->wx, m->by, w, bh, 0, DefaultDepth(dpy, screen),
 				CopyFromParent, DefaultVisual(dpy, screen),
 				CWOverrideRedirect|CWBackPixmap|CWEventMask, &wa);
 		XDefineCursor(dpy, m->barwin, cursor[CurNormal]->cursor);
+		if (showsystray && m == systraytomon(m))
+			XMapRaised(dpy, systray->win);
 		XMapRaised(dpy, m->barwin);
 		XSetClassHint(dpy, m->barwin, &ch);
 	}
@@ -1996,9 +2382,127 @@
 	if (!gettextprop(root, XA_WM_NAME, stext, sizeof(stext)))
 		strcpy(stext, "dwm-"VERSION);
 	drawbar(selmon);
+	updatesystray();
 }
 
 void
+updatesystrayicongeom(Client *i, int w, int h)
+{
+	if (i) {
+		i->h = bh;
+		if (w == h)
+			i->w = bh;
+		else if (h == bh)
+			i->w = w;
+		else
+			i->w = (int) ((float)bh * ((float)w / (float)h));
+		applysizehints(i, &(i->x), &(i->y), &(i->w), &(i->h), False);
+		/* force icons into the systray dimensions if they don't want to */
+		if (i->h > bh) {
+			if (i->w == i->h)
+				i->w = bh;
+			else
+				i->w = (int) ((float)bh * ((float)i->w / (float)i->h));
+			i->h = bh;
+		}
+	}
+}
+
+void
+updatesystrayiconstate(Client *i, XPropertyEvent *ev)
+{
+	long flags;
+	int code = 0;
+
+	if (!showsystray || !i || ev->atom != xatom[XembedInfo] ||
+			!(flags = getatomprop(i, xatom[XembedInfo])))
+		return;
+
+	if (flags & XEMBED_MAPPED && !i->tags) {
+		i->tags = 1;
+		code = XEMBED_WINDOW_ACTIVATE;
+		XMapRaised(dpy, i->win);
+		setclientstate(i, NormalState);
+	}
+	else if (!(flags & XEMBED_MAPPED) && i->tags) {
+		i->tags = 0;
+		code = XEMBED_WINDOW_DEACTIVATE;
+		XUnmapWindow(dpy, i->win);
+		setclientstate(i, WithdrawnState);
+	}
+	else
+		return;
+	sendevent(i->win, xatom[Xembed], StructureNotifyMask, CurrentTime, code, 0,
+			systray->win, XEMBED_EMBEDDED_VERSION);
+}
+
+void
+updatesystray(void)
+{
+	XSetWindowAttributes wa;
+	XWindowChanges wc;
+	Client *i;
+	Monitor *m = systraytomon(NULL);
+	unsigned int x = m->mx + m->mw;
+	unsigned int sw = TEXTW(stext) - lrpad + systrayspacing;
+	unsigned int w = 1;
+
+	if (!showsystray)
+		return;
+	if (systrayonleft)
+		x -= sw + lrpad / 2;
+	if (!systray) {
+		/* init systray */
+		if (!(systray = (Systray *)calloc(1, sizeof(Systray))))
+			die("fatal: could not malloc() %u bytes\n", sizeof(Systray));
+		systray->win = XCreateSimpleWindow(dpy, root, x, m->by, w, bh, 0, 0, scheme[SchemeSel][ColBg].pixel);
+		wa.event_mask        = ButtonPressMask | ExposureMask;
+		wa.override_redirect = True;
+		wa.background_pixel  = scheme[SchemeNorm][ColBg].pixel;
+		XSelectInput(dpy, systray->win, SubstructureNotifyMask);
+		XChangeProperty(dpy, systray->win, netatom[NetSystemTrayOrientation], XA_CARDINAL, 32,
+				PropModeReplace, (unsigned char *)&netatom[NetSystemTrayOrientationHorz], 1);
+		XChangeWindowAttributes(dpy, systray->win, CWEventMask|CWOverrideRedirect|CWBackPixel, &wa);
+		XMapRaised(dpy, systray->win);
+		XSetSelectionOwner(dpy, netatom[NetSystemTray], systray->win, CurrentTime);
+		if (XGetSelectionOwner(dpy, netatom[NetSystemTray]) == systray->win) {
+			sendevent(root, xatom[Manager], StructureNotifyMask, CurrentTime, netatom[NetSystemTray], systray->win, 0, 0);
+			XSync(dpy, False);
+		}
+		else {
+			fprintf(stderr, "dwm: unable to obtain system tray.\n");
+			free(systray);
+			systray = NULL;
+			return;
+		}
+	}
+	for (w = 0, i = systray->icons; i; i = i->next) {
+		/* make sure the background color stays the same */
+		wa.background_pixel  = scheme[SchemeNorm][ColBg].pixel;
+		XChangeWindowAttributes(dpy, i->win, CWBackPixel, &wa);
+		XMapRaised(dpy, i->win);
+		w += systrayspacing;
+		i->x = w;
+		XMoveResizeWindow(dpy, i->win, i->x, 0, i->w, i->h);
+		w += i->w;
+		if (i->mon != m)
+			i->mon = m;
+	}
+	w = w ? w + systrayspacing : 1;
+	x -= w;
+	XMoveResizeWindow(dpy, systray->win, x, m->by, w, bh);
+	wc.x = x; wc.y = m->by; wc.width = w; wc.height = bh;
+	wc.stack_mode = Above; wc.sibling = m->barwin;
+	XConfigureWindow(dpy, systray->win, CWX|CWY|CWWidth|CWHeight|CWSibling|CWStackMode, &wc);
+	XMapWindow(dpy, systray->win);
+	XMapSubwindows(dpy, systray->win);
+	/* redraw background */
+	XSetForeground(dpy, drw->gc, scheme[SchemeNorm][ColBg].pixel);
+	XFillRectangle(dpy, systray->win, drw->gc, 0, 0, w, bh);
+	XSync(dpy, False);
+}
+
+void
 updatetitle(Client *c)
 {
 	if (!gettextprop(c->win, netatom[NetWMName], c->name, sizeof c->name))
@@ -2063,6 +2567,16 @@
 	return NULL;
 }
 
+Client *
+wintosystrayicon(Window w) {
+	Client *i = NULL;
+
+	if (!showsystray || !w)
+		return i;
+	for (i = systray->icons; i && i->win != w; i = i->next) ;
+	return i;
+}
+
 Monitor *
 wintomon(Window w)
 {
@@ -2116,6 +2630,22 @@
 	return -1;
 }
 
+Monitor *
+systraytomon(Monitor *m) {
+	Monitor *t;
+	int i, n;
+	if(!systraypinning) {
+		if(!m)
+			return selmon;
+		return m == selmon ? m : NULL;
+	}
+	for(n = 1, t = mons; t && t->next; n++, t = t->next) ;
+	for(i = 1, t = mons; t && t->next && i < systraypinning; i++, t = t->next) ;
+	if(systraypinningfailfirst && n < systraypinning)
+		return mons;
+	return t;
+}
+
 void
 zoom(const Arg *arg)
 {
@@ -2130,6 +2660,26 @@
 	pop(c);
 }
 
+/** Function to shift the current view to the left/right
+ *
+ * @param: "arg->i" stores the number of tags to shift right (positive value)
+ *          or left (negative value)
+ */
+void
+shiftview(const Arg *arg) {
+	Arg shifted;
+
+	if(arg->i > 0) // left circular shift
+		shifted.ui = (selmon->tagset[selmon->seltags] << arg->i)
+		   | (selmon->tagset[selmon->seltags] >> (LENGTH(tags) - arg->i));
+
+	else // right circular shift
+		shifted.ui = selmon->tagset[selmon->seltags] >> (- arg->i)
+		   | selmon->tagset[selmon->seltags] << (LENGTH(tags) + arg->i);
+
+	view(&shifted);
+}
+
 int
 main(int argc, char *argv[])
 {
@@ -2148,7 +2698,9 @@
 		die("pledge");
 #endif /* __OpenBSD__ */
 	scan();
+	runautostart();
 	run();
+    runautostop();
 	cleanup();
 	XCloseDisplay(dpy);
 	return EXIT_SUCCESS;
