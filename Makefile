# ==== GBDK Makefile adapté pour Windows (avec mingw32-make) ====
# | Compile les fichiers .c et .s dans les sous-dossiers "src"  |
# | et "res" et place le resultat dans le sous-dossier "obj"    |
# |                                                             |
# | mingw32-make : Compile la ROM .gb                           |
# | mingw32-make clean : Nettoie les fichiers de compilation    |
# ===============================================================

# Si vous déplacez GBDK, modifiez la ligne ci-dessous
# pour que la variable GBDK_HOME pointe vers votre GBDK (ex. : "C:\GBDK\")
ifndef GBDK_HOME
	GBDK_HOME = "C:\GBDK\"
endif

# Le compilateur LCC est un exécutable .exe dans le sous-dossier "bin" de GBDK
LCC = $(GBDK_HOME)bin\lcc 

# Activer la compilation en mode debug (mingw32-make GBDK_DEBUG=1)
ifdef GBDK_DEBUG
    LCCFLAGS += -debug -v
    LCCFLAGS += -Wa-l -Wl-m -Wl-j -DUSE_SFR_FOR_REG
else
    LCCFLAGS += -Wa-l -Wl-m -Wl-j -DUSE_SFR_FOR_REG
endif

# Vous pouvez modifier le nom de la ROM .gb ici
PROJECTNAME = game

# Noms des dossiers
SRCDIR      = src
OBJDIR      = obj
RESDIR      = res
BINS	    = $(OBJDIR)/$(PROJECTNAME).gb

# Détection des fichiers sources (.c, .s)
CSOURCES    = $(foreach dir,$(SRCDIR),$(notdir $(wildcard $(dir)/*.c))) \
              $(foreach dir,$(RESDIR),$(notdir $(wildcard $(dir)/*.c)))
ASMSOURCES  = $(foreach dir,$(SRCDIR),$(notdir $(wildcard $(dir)/*.s)))
OBJS        = $(CSOURCES:%.c=$(OBJDIR)/%.o) $(ASMSOURCES:%.s=$(OBJDIR)/%.o)

all: prepare $(BINS)

# Compile .c files in "src/" to .o object files
# Compile les fichiers .c de "src/" en fichiers .o (objets)
$(OBJDIR)/%.o:  $(SRCDIR)/%.c
	$(LCC) $(LCCFLAGS) -c -o $@ $<

# Compile les fichiers .c de "res/" en fichiers .o (objets)
$(OBJDIR)/%.o:  $(RESDIR)/%.c
	$(LCC) $(LCCFLAGS) -c -o $@ $<

# Compile les fichiers assembleurs .s de "src/" en fichiers .o (objets)
$(OBJDIR)/%.o:  $(SRCDIR)/%.s
	$(LCC) $(LCCFLAGS) -c -o $@ $<

# Si besoin, compile les fichiers .c de "src/" en fichiers .s (assembleur)
# (inutile si les fichiers .c sont directement compilés en .o)
$(OBJDIR)/%.s:  $(SRCDIR)/%.c
	$(LCC) $(LCCFLAGS) -S -o $@ $<

# Lie les objets compilés en un fichier .gb
$(BINS):    $(OBJS)
	$(LCC) $(LCCFLAGS) -o $(BINS) $(OBJS)

prepare:
    # Crée le dossier "obj" s'il n'existe pas.
    # La redirection d'erreur est silencieuse
	mkdir $(OBJDIR) 2>NUL || set /a 0

# Nettoie les fichiers de compilation (mingw32-make clean)
clean:
	@echo "Nettoyage..."
	del /Q $(OBJDIR)\*.* 2>NUL
	del /Q $(PROJECTNAME).gb $(PROJECTNAME).ihx $(PROJECTNAME).cdb $(PROJECTNAME).adb $(PROJECTNAME).noi $(PROJECTNAME).map 2>NUL
	-rmdir $(OBJDIR) 2>NUL
	@echo "[OK] Nettoyage terminé."