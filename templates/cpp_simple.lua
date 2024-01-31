local main = [[
#include<iostream>;

using namespace std;

int main()
{
  cout << "Hello world !" << endl;
}
]]

local build = [[
#!/usr/bin/bash

# Compile
g++ main.cpp -o ./bin/main

# Run
./bin/main
]]

local directories = {}

-- TODO: exec files need a true/false variable
local files = {
  ["main.cpp"] = main,
  ["build.sh"] = build
}
