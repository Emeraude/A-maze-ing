SRC = step1.ml

OCAMLFLAGS = -w Aelz -warn-error A -g

all: step1 step1.byte

byte: step1.byte

native: step1.native

step1: step1.native
	cp $< $@

step1.byte: $(SRC)
	ocamlc $(OCAMLFLAGS) $^ -o $@

step1.native: $(SRC)
	ocamlopt $(OCAMLFLAGS) $^ -o $@

clean:
	$(RM) *.cmo *.cmi *.o *.cmx

fclean: clean
	$(RM) step1 step1.byte step1.native

re: fclean all

.PHONY: all clean fclean re byte native
