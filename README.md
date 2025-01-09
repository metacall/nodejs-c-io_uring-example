# [MetaCall](https://github.com/metacall/core) NodeJS C `io_uring` Example

[`io_uring`](https://en.wikipedia.org/wiki/Io_uring) is a new Linux Kernel interface that speeds up I/O operations in comparison to previous implementations like [`libuv`](https://libuv.org/) (the library that NodeJS uses internally for handling I/O).

This interface is offered through [`liburing`](https://github.com/axboe/liburing), which provides a C API for accessing it. We could write a NodeJS extension by using [`N-API`](https://nodejs.org/api/n-api.html), or use [`ffi`](https://www.npmjs.com/package/ffi) in order to call to the library.

Developing those wrappers is costly because either we have to write C/C++ or JavaScript boilerplate. So instead of doing that, we will be using [MetaCall](https://github.com/metacall/core) in order to achieve this.

MetaCall allows to transparently call to C functions, we can implement anything in C and without need to compile it manually (it will be JITed at load time). So basically we can load C code directly into NodeJS. For example:

```c
int sum(int a, int b) {
	return a + b;
}
```

```js
const { sum } = require("./sum.c");

sum(3, 4) // 7
```

With this we can use our C library not only from NodeJS but from any other language, for example, Python:

```py
from sum.c import sum

sum(3, 4) # 7
```

We will be avoiding all the boilerplate and we will have a single interface for all languages. The calls will be also type safe and we will avoid a lot of errors and time for maintaining the wrappers for each language that we can spend focusing on the development.

In this example we want to bring the power of `io_uring` to NodeJS for maximizing the speed of I/O and outperform NodeJS native primitives like `http` module. For demonstrating it, we have a `server_listen` function which creates a simple HTTP server in the port `28977`.

## Docker

Building and running with Docker:

```bash
docker build -t metacall/nodejs-c-liburing-example .
docker run --rm -p 28977:28977 -it metacall/nodejs-c-liburing-example
```

## Accessing to the website

Just go to your web browser and enter this url: `localhost:28977`
