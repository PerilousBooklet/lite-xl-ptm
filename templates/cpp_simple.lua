main = [[
#include<iostream>;

using namespace std;

int main()
{
  cout << "Hello world !" << endl;
}
]]

build = [[
#!/usr/bin/bash

# Compile
g++ main.cpp -o ./bin/main

# Run
./bin/main
]]

directories = {}

-- TODO: exec files need a true/false variable
files = {
  ["main.cpp"] = main,
  ["build.sh"] = build
}
