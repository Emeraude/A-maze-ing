SRC1 = tile.ml maze.ml step1.ml
SRC2 = tile.ml maze.ml draw.ml step2.ml

OCAMLFLAGS = -w Aelz -warn-error A -g

all: step1 step1.byte step2 step2.byte

# Step1

step1: step1.native
	cp $< $@

step1.byte: $(SRC1)
	ocamlc $(OCAMLFLAGS) $^ -o $@

step1.native: $(SRC1)
	ocamlopt $(OCAMLFLAGS) $^ -o $@

# Step2

step2: step2.native
	cp $< $@

step2.byte: $(SRC2)
	ocamlfind ocamlc $(OCAMLFLAGS) $^ -o $@ -package ocamlsdl -linkpkg

step2.native: $(SRC2)
	ocamlfind ocamlopt $(OCAMLFLAGS) $^ -o $@ -package ocamlsdl -linkpkg

clean:
	$(RM) *.cmo *.cmi *.o *.cmx

fclean: clean
	$(RM) step1 step1.byte step1.native step2 step2.native step2.byte

re: fclean all

.PHONY: all clean fclean re
