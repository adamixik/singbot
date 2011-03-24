CC=g++
CFLAGS=-c -g -Wall -D_SERVER -D_LINUX -w -ISingBot -ISingBot/scripting -ISingBot/squirrel -IIRC
SOURCES=$(wildcard SingBot/*.cpp)
SOURCES+=$(wildcard SingBot/scripting/*.cpp)
SOURCES+=$(wildcard SingBot/scripting/natives/*.cpp)
SOURCES+=$(wildcard SingBot/squirrel/*.cpp)
SOURCES+=$(wildcard SingBot/TinyXML/*.cpp)
SOURCES+=IRC/IRC.cpp
OBJECTS=$(SOURCES:.cpp=.o)
EXECUTABLE=Debug/SingBot2
PCH=SingBot/Main.h

all: $(SOURCES) $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS) 
	g++ $(OBJECTS) -lpthread -ldl -o $@ 

.cpp.o:
	$(CC) $(CFLAGS) $< -o $@

pch:
	$(CC) $(CFLAGS) $(PCH) -o $(PCH).gch

clean:
	rm -Rf $(OBJECTS) $(EXECUTABLE)
