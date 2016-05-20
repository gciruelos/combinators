comb: comb.hs
	ghc -Wall -O2 comb.hs -o comb

clean:
	rm -rf comb *.o *.hi
