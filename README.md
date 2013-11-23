bf
==

Brainfuck interpreter in node.js using streams.

I wanted to write an interpreter and learn a bit about streams at the same time so here we are. Unfortunately since (at least naively) brainfuck requires reading the whole file (for stuff like jumps) we don't really take advantage of the streaming but whatever.
