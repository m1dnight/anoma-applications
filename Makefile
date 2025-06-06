# directory to put compiled juvix files

#-----------------------------------------------------------
# Spacebucks

SPACEBUCKS_DST := priv/juvix/.compiled/Spacebucks
SPACEBUCKS_SRC := priv/juvix/Spacebucks
SPACE_BUCKS_JUVIX_FILES := $(SPACEBUCKS_SRC)/Mint.juvix     \
						   $(SPACEBUCKS_SRC)/Transfer.juvix \
						   $(SPACEBUCKS_SRC)/Logic.juvix

SPACEBUCKS_NOCKMA_FILES := $(patsubst $(SPACEBUCKS_SRC)/%.juvix,$(SPACEBUCKS_DST)/%.nockma,$(SPACE_BUCKS_JUVIX_FILES))

# rule to compile a single Juvix file to a Nockma file
# the - supresses failures of the compilation command.
# this is necessary because some juvix files dont have a main function
$(SPACEBUCKS_DST)/%.nockma: $(SPACEBUCKS_SRC)/%.juvix
	@mkdir -p $(SPACEBUCKS_DST)
	juvix compile anoma $< -o $@

#-----------------------------------------------------------
# Metamask Spacebucks

MM_SPACEBUCKS_DST := priv/juvix/.compiled/SpacebucksMetaMask
MM_SPACEBUCKS_SRC := priv/juvix/SpacebucksMetaMask
MM_SPACE_BUCKS_JUVIX_FILES := $(MM_SPACEBUCKS_SRC)/Mint.juvix          \
							  $(MM_SPACEBUCKS_SRC)/Logic.juvix         \
							  $(MM_SPACEBUCKS_SRC)/CreateAppData.juvix \
							  $(MM_SPACEBUCKS_SRC)/GetPublicKey.juvix

MM_SPACEBUCKS_NOCKMA_FILES := $(patsubst $(MM_SPACEBUCKS_SRC)/%.juvix,$(MM_SPACEBUCKS_DST)/%.nockma,$(MM_SPACE_BUCKS_JUVIX_FILES))

# rule to compile a single Juvix file to a Nockma file
# the - supresses failures of the compilation command.
# this is necessary because some juvix files dont have a main function
$(MM_SPACEBUCKS_DST)/%.nockma: $(MM_SPACEBUCKS_SRC)/%.juvix
	@mkdir -p $(MM_SPACEBUCKS_DST)
	juvix compile anoma $< -o $@

#-----------------------------------------------------------
# Generic rules

# the list of all possible nockma files we might want to compile
NOCKMA_FILES := $(MM_SPACEBUCKS_NOCKMA_FILES) $(SPACEBUCKS_NOCKMA_FILES)

# compile all the nockma files
all: $(NOCKMA_FILES)

# clean out all the compiled files
clean:
	@cd priv/juvix/ ; juvix clean
	rm -rf $(NOCKMA_FILES)
