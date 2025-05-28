# directory to put compiled juvix files
COMPILED_DIR := priv/juvix/.compiled

# Spacebucks Juvix files
SPACEBUCKS_SRC_DIR := priv/juvix/Spacebucks
SPACE_BUCKS_JUVIX_FILES := $(SPACEBUCKS_SRC_DIR)/Mint.juvix $(SPACEBUCKS_SRC_DIR)/Transfer.juvix $(SPACEBUCKS_SRC_DIR)/Logic.juvix
SPACEBUCKS_NOCKMA_FILES := $(patsubst $(SPACEBUCKS_SRC_DIR)/%.juvix,$(COMPILED_DIR)/%.nockma,$(SPACE_BUCKS_JUVIX_FILES))

# Other apps go here.

# Aggregate of all apps and their source files.
JUVIX_FILES := $(SPACE_BUCKS_JUVIX_FILES)
NOCKMA_FILES := $(SPACEBUCKS_NOCKMA_FILES)

# rule to compile a single Juvix file to a Nockma file
# the - supresses failures of the compilation command.
# this is necessary because some juvix files dont have a main function
$(COMPILED_DIR)/%.nockma: $(SPACEBUCKS_SRC_DIR)/%.juvix
	@mkdir -p $(COMPILED_DIR)
	juvix compile anoma $< -o $@

all: $(NOCKMA_FILES)

clean:
	@cd priv/juvix/ ; juvix clean
	@rm -rf $(NOCKMA_FILES)
