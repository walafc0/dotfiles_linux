/* See LICENSE file for copyright and license details. */

#include <X11/XF86keysym.h>
/* appearance */
static const char font[]            = "Inconsolata-9";
static const char normbordercolor[] = "#333333";
static const char normbgcolor[]     = "#051121";
static const char normfgcolor[]     = "#615A5A";
static const char selbordercolor[]  = "#9BB5C3";
static const char selbgcolor[]      = "#9BB5C3";
static const char selfgcolor[]      = "#FFFFFF";
static const unsigned int borderpx  = 1;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const unsigned int minwsz    = 20;       /* Minimal heigt of a client for smfact */
static const Bool showbar           = True;     /* False means no bar */
static const Bool topbar            = True;     /* False means bottom bar */

/* tagging */
static const char *tags[] = { "Web", "Docs", "Term", "4", "5", "6", "IRC", "Multimedia", "Trash" };

/* Sort by tag number */
static const Rule rules[] = {
	/* class      instance    title       tags mask     isfloating   monitor */
	{ "Uzbl",     NULL,       NULL,       1 << 0,       False,       -1 },
	{ "Firefox",  NULL,       NULL,       1 << 0,       False,       -1 },
        { "Gimp",     NULL,       NULL,       1 << 1,       True,        -1 },
        { "Xsane",    NULL,       NULL,       1 << 1,       True,        -1 },	
	{ "libreoffice-calc", NULL, NULL,     1 << 1,       False,       -1 },
	{ "libreoffice-writer", NULL, NULL,   1 << 1,       False,       -1 },
	{ "Zathura",  NULL,       NULL,       1 << 1,       False,       -1 },
        { NULL, NULL,       "rootlocalgh0st", 1 << 2,       False,       -1 },
	{ NULL,	      NULL,       "irssi",    1 << 6,       False,       -1 },
	{ NULL,	      NULL,       "turses",   1 << 6,       False,       -1 },
	{ NULL,       NULL,       "cmus",     1 << 7,       False,       -1 },
        { "MPlayer",  NULL,       NULL,       1 << 7,       True,        -1 },
	{ "Easytag",  NULL,       NULL,       1 << 7,       False,       -1 },
	{ NULL,       NULL,       "tunnel",   1 << 8,       False,       -1 }
};

/* layout(s) */
static const float mfact      = 0.55; /* factor of master area size [0.05..0.95] */
static const float smfact     = 0.00; /* factor of tiled clients [0.00..0.95] */
static const int nmaster      = 1;    /* number of clients in master area */
static const Bool resizehints = False; /* True means respect size hints in tiled resizals */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "[M]",      monocle },
	{ "><>",      NULL },    /* no layout function means floating behavior */
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      comboview,      {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      combotag,       {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

#define SCRIPTS_DIR "/home/walafc0/.scripts"

/* commands */
static const char *dmenucmd[]      = { "dmenu_run", "-fn", font, "-nb", normbgcolor, "-nf", normfgcolor, "-sb", selbgcolor, "-sf", selfgcolor, NULL };
static const char *termcmd[]       = { "urxvt", "-title", "urxvt", NULL };
static const char *irssicmd[]      = { "urxvt", "-title", "irssi", "-e", "ssh", "walafc0@kim", "-t", "screen", "-rd", NULL };
static const char *uzblcmd[]       = { "uzbl-tabbed", NULL };
static const char *cmuscmd[]	   = { "urxvt", "-title", "cmus", "-e", SCRIPTS_DIR"/cmus", NULL };
static const char *tunnelcmd[]	   = { "urxvt", "-title", "tunnel", "-e", SCRIPTS_DIR"/tunnel", NULL };
static const char *roottermcmd[]   = { "urxvt", "-title", "root@localgh0st", "-e", "su", "root", NULL };
static const char *volup[]         = { "amixer", "-q", "sset", "Master", "5%+", "unmute", NULL };
static const char *voldown[]       = { "amixer", "-q", "sset", "Master", "5%-", "unmute", NULL };
static const char *mutecmd[]       = { SCRIPTS_DIR"/mute", NULL };
static const char *pausecmd[]      = { "urxvt", "-e", "cmus-remote", " -u", NULL };

/* TODO: create an header for this patch */
#include "movestack.c"
static Key keys[] = {
	/* modifier                     key        function        argument */
	{ MODKEY,                       XK_p,      spawn,          {.v = dmenucmd } },
	{ MODKEY,                       XK_Return, spawn,          {.v = termcmd } },
	{ MODKEY|ShiftMask,             XK_Return, spawn,          {.v = roottermcmd } },
	{ MODKEY,                       XK_b,      togglebar,      {0} },
	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_i,      incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },
	{ MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },

	/* Allow to resize height */
	{ MODKEY|ShiftMask,             XK_h,      setsmfact,      {.f = +0.05} },
        { MODKEY|ShiftMask,             XK_l,      setsmfact,      {.f = -0.05} },

	/* { MODKEY|ShiftMask,             XK_Return, zoom,           {0} }, */
	{ MODKEY,                       XK_Tab,    view,           {0} },
	{ MODKEY|ShiftMask,             XK_c,      killclient,     {0} },
	{ MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
	{ MODKEY,                       XK_m,      setlayout,      {.v = &layouts[1]} },
	{ MODKEY,                       XK_f,      setlayout,      {.v = &layouts[2]} },
	{ MODKEY,                       XK_space,  setlayout,      {0} },
	{ MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },

	{ MODKEY,			XK_i,	   spawn,	   {.v = irssicmd } },
	{ MODKEY,			XK_u,	   spawn,	   {.v = uzblcmd } },
	{ MODKEY,			XK_c,	   spawn,	   {.v = cmuscmd } },
	{ MODKEY|ShiftMask,		XK_t,	   spawn,	   {.v = tunnelcmd } },
	/* Allow to switch windows location between us */
	{ MODKEY|ShiftMask,             XK_j,      movestack,      {.i = +1 } },
        { MODKEY|ShiftMask,             XK_k,      movestack,      {.i = -1 } },

#define PLAYPAUSE_KEY 0x1008ff2f
#define MUTE_KEY 0x1008ff12 

	{ 0,           XF86XK_AudioRaiseVolume,    spawn,          {.v = volup } },
	{ 0,           XF86XK_AudioLowerVolume,    spawn,          {.v = voldown } },
        { 0,           PLAYPAUSE_KEY,              spawn,          {.v = pausecmd } },
	{ 0,           MUTE_KEY,                   spawn,          {.v = mutecmd } },


	TAGKEYS(                        0x26,                      0)
	TAGKEYS(                        0xe9,                      1)
	TAGKEYS(                        0x22,                      2)
	TAGKEYS(                        0x27,                      3)
	TAGKEYS(                        0x28,                      4)
	TAGKEYS(                        0x2d,                      5)
	TAGKEYS(                        0xe8,                      6)
	TAGKEYS(                        0x5f,                      7)
	TAGKEYS(                        0xe7,                      8)

	{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },
};

/* button definitions */
/* click can be ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

