CXX = g++
LIBS = -lsfml-graphics -lsfml-window -lsfml-system

build: 
	$(CXX) -c main.cpp -o main.o
	$(CXX) main.o $(LIBS) -o eyecare
	$(info --- print line to crontab ---)
	$(info */15 * * * * env DISPLAY=:0 $HOME/dotfiles/eyecare/eyecare)
	$(info )

.PHONY: clean

clean:
	rm -f main.o
