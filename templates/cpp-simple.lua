-- code blocks are stored inside multi-line strings
-- code blocks are to be written inside generated files

local hello_world = [[
#include<iostream>;

using namespace std;

int main()
{
  cout << "Hello world !" << endl;
}
]]

local build = [[

]]

local run = [[

]]

-- comprehensive table that contains the references to all tables that template_generator needs to generate and fill the files
local main = {
  -- ?
}
