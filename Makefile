SRC1 = door.ml tile.ml maze.ml display.ml step1.ml
SRC2 = door.ml tile.ml maze.ml draw.ml step2.ml
SRC3 = door.ml tile.ml maze.ml draw.ml solve.ml step3.ml
SRC4 = door.ml tile.ml maze.ml draw.ml draw_hex.ml solve.ml step4.ml

OCAMLFLAGS = -w Aelz -warn-error A -g

all: step1 step1.byte step2 step2.byte step3 step3.byte step4 step4.byte

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
	ocamlfind ocamlc $(OCAMLFLAGS) $^ -o $@ -package sdl -package sdl.sdlimage -linkpkg

step2.native: $(SRC2)
	ocamlfind ocamlopt $(OCAMLFLAGS) $^ -o $@ -package sdl -package sdl.sdlimage -linkpkg

# Step3

step3: step3.native
	cp $< $@

step3.byte: $(SRC3)
	ocamlfind ocamlc $(OCAMLFLAGS) $^ -o $@ -package sdl -package sdl.sdlimage -linkpkg

step3.native: $(SRC3)
	ocamlfind ocamlopt $(OCAMLFLAGS) $^ -o $@ -package sdl -package sdl.sdlimage -linkpkg

# Step4

step4: step4.native
	cp $< $@

step4.byte: $(SRC4)
	ocamlfind ocamlc $(OCAMLFLAGS) $^ -o $@ -package sdl -package sdl.sdlimage -linkpkg

step4.native: $(SRC4)
	ocamlfind ocamlopt $(OCAMLFLAGS) $^ -o $@ -package sdl -package sdl.sdlimage -linkpkg

clean:
	$(RM) *.cmo *.cmi *.o *.cmx

fclean: clean
	$(RM) step1 step1.byte step1.native step2 step2.native step2.byte step3 step3.byte step3.native

re: fclean all

.PHONY: all clean fclean re
