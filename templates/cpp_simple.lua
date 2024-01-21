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

items = {
  main = "main.cpp",
  build = "build.sh"
}
