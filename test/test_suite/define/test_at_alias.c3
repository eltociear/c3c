module foo<Type>;
import std::io;

macro @hello(Type thing) {
    io::printfln("%d", $sizeof(thing));
}

module bar;

import private foo;

define @intHello = foo::@hello<int>;

fn void main(char[][] args) {
    @intHello(42);
}