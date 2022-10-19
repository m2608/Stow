--- config.def.h.orig	2022-01-07 14:41:35.000000000 +0300
+++ config.def.h	2022-06-17 21:13:59.361280000 +0300
@@ -135,13 +135,19 @@
 static unsigned int defaultrcs = 257;
 
 /*
- * Default shape of cursor
- * 2: Block ("█")
- * 4: Underline ("_")
- * 6: Bar ("|")
- * 7: Snowman ("☃")
+ * Default style of cursor
+ * 0: Blinking block
+ * 1: Blinking block (default)
+ * 2: Steady block ("█")
+ * 3: Blinking underline
+ * 4: Steady underline ("_")
+ * 5: Blinking bar
+ * 6: Steady bar ("|")
+ * 7: Blinking st cursor
+ * 8: Steady st cursor
  */
-static unsigned int cursorshape = 2;
+static unsigned int cursorshape = 1;
+static Rune stcursor = 0x2603; /* snowman (U+2603) */
 
 /*
  * Default columns and rows numbers
