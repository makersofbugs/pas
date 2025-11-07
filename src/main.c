#include <lauxlib.h>
#include <lua.h>
#include <lualib.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv) {
  printf("Hello World\n");

  int status, result;
  lua_State *L;
  L = luaL_newstate();
  luaL_openlibs(L);

  status = luaL_dofile(L, "pas.lua");
  if (status) {
    fprintf(stderr, "Couldn't load file: %s\n", lua_tostring(L, -1));
    exit(1);
  }

  lua_getglobal(L, "f"); /* function to be called */
  lua_pushnumber(L, 1);  /* push 1st argument */
  lua_pushnumber(L, 2);  /* push 2nd argument */

  if (lua_pcall(L, 2, 1, 0) != 0) {
    fprintf(stderr, "error running function `f': %s\n", lua_tostring(L, -1));
    exit(1);
  }

  /* retrieve result */
  if (!lua_isnumber(L, -1)) {
    fprintf(stderr, "function `f' must return a number");
    exit(1);
  }
  int z = lua_tonumber(L, -1);
  printf("Result is: %d\n", z);
  lua_pop(L, 1); /* pop returned value */

  lua_getglobal(L, "hi"); /* function to be called */
  if (lua_pcall(L, 0, 0, 0) != 0) {
    fprintf(stderr, "error running function `hi': %s\n", lua_tostring(L, -1));
    exit(1);
  }

  lua_close(L);

  return 0;
}
