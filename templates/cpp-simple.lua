local main = [[
#include<iostream>;

using namespace std;

int main()
{
  cout << "Hello world !" << endl;
}
]]

local run = [[
#!/bin/bash

# Compile
g++ main.cpp -o ./bin/main

# Run
./bin/main
]]
