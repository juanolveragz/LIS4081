SRC_DIR			:= src
ORG_DIR			:= $(SRC_DIR)/org
OUTLINE_DIR		:= $(ORG_DIR)/outline
SLIDES_DIR		:= $(ORG_DIR)/slides
EXAMPLES_DIR		:= $(SRC_DIR)/examples/org
BUILD_DIR		:= build
BUILD_SLIDES_DIR	:= $(BUILD_DIR)/slides
BUILD_OUTLINE_DIR	:= $(BUILD_DIR)/outline
BUILD_EXAMPLES_DIR	:= $(BUILD_DIR)/examples
OUTPUT_DIR		:= output
OUTPUT_SLIDES_DIR	:= $(OUTPUT_DIR)/slides
OUTPUT_OUTLINE_DIR	:= $(OUTPUT_DIR)/outline
OUTPUT_EXAMPLES_DIR     := $(OUTPUT_DIR)/examples

$(SLIDES_DIR)/%.tex: $(SLIDES_DIR)/%.org
	emacs --batch -load "~/.emacs.d/cli-latex.el" $< -f org-beamer-export-to-latex

$(BUILD_SLIDES_DIR)/%.pdf: $(SLIDES_DIR)/%.tex
	latexmk -silent -g -bibtex -pdflatex=lualatex -interaction=nonstopmode -shell-escape -outdir=$(BUILD_SLIDES_DIR) -pdf $<
	rm $<

$(OUTPUT_SLIDES_DIR)/%.pdf: $(BUILD_SLIDES_DIR)/%.pdf
	cp $< $@

slides: $(shell find $(SLIDES_DIR) -name '*.org' | sed s:$(ORG_DIR):$(OUTPUT_DIR): | sed s:.org:.pdf:)

$(OUTLINE_DIR)/%.tex: $(OUTLINE_DIR)/%.org
	emacs --batch -load "~/.emacs.d/cli-latex.el" $< -f org-latex-export-to-latex

$(BUILD_OUTLINE_DIR)/%.pdf: $(OUTLINE_DIR)/%.tex
	latexmk -silent -g -bibtex -pdflatex=lualatex -interaction=nonstopmode -shell-escape -outdir=$(BUILD_OUTLINE_DIR) -pdf $<
	rm $<

$(OUTPUT_OUTLINE_DIR)/%.pdf: $(BUILD_OUTLINE_DIR)/%.pdf
	cp $< $@

outlines: $(shell find $(OUTLINE_DIR) -name '*.org' | sed s:$(ORG_DIR):$(OUTPUT_DIR): | sed s:.org:.pdf:)

$(EXAMPLES_DIR)/%.tex: $(EXAMPLES_DIR)/%.org
	emacs --batch -load "~/.emacs.d/cli-latex.el" $< -f org-latex-export-to-latex

$(BUILD_EXAMPLES_DIR)/%.pdf: $(EXAMPLES_DIR)/%.tex
	latexmk -silent -g -bibtex -pdflatex=lualatex -interaction=nonstopmode -shell-escape -outdir=$(BUILD_EXAMPLES_DIR) -pdf $<

$(OUTPUT_EXAMPLES_DIR)/%.pdf: $(BUILD_EXAMPLES_DIR)/%.pdf
	cp $< $@

examples_pdf: $(shell find $(EXAMPLES_DIR) -name '*.org' | sed s:$(EXAMPLES_DIR):$(OUTPUT_EXAMPLES_DIR): | sed s:.org:.pdf:)

$(ORG_DIR)/syllabus.tex: $(ORG_DIR)/syllabus.org
	emacs --batch -load "~/.emacs.d/cli-latex.el" $< -f org-latex-export-to-latex

$(BUILD_DIR)/syllabus.pdf: $(ORG_DIR)/syllabus.tex
	latexmk -silent -g -bibtex -pdflatex=lualatex -interaction=nonstopmode -shell-escape -outdir=$(BUILD_DIR) -pdf $<
	rm $<

$(OUTPUT_DIR)/syllabus.pdf: $(BUILD_DIR)/syllabus.pdf
	cp $< $@

syllabus: $(OUTPUT_DIR)/syllabus.pdf
