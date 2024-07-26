<h1 align="center">FiveM Typescript Boilerplate</h1>
This is my own boilerplate for my new typescript resources
I tried multiple one recently and I always encounters problems with them.
They where not updated, not working or not corresponding to my usual structure of files nor was near it.
So I decided to make my own*

*I do not claim that I'm better than anyone. I tried like 10 boilerplate/template and none of them was working for me. If you want to use it, it will be a pleasure.*

## Here's how the structure works
- bridge: this is a LUA bridge that can easily be modified by customers / server owners with no TS knowledge.
- build: is not limited to 1 or 2 files. You can create the amount of client/server files you want.
- data: config, etc. You can set whatever json files you want.
- locales: json files used for ox_lib locales system.
- src: TS source files, compiler, etc.
- fxmanifest: the manifest file that make the resource work.

## Credits
I took code from 2 repositories:
* https://github.com/project-error/fivem-typescript-boilerplate
* https://github.com/overextended/ox_core-example
* Thank you to Project Error and OverExtended for there base code!
* I completly redid the file structure, I'm the author of the bridge, I edited the build.js but I'm not the creator of the default code and it's important to say so.

## Requirements
* Typescript knowledge
* Node > v16
* Yarn

## Getting Started

First clone the repository or use the template option 
and place it within your `resources` folder

**Install Dependencies**

Navigate into the newly cloned folder and execute
the following command, to install dependencies.

```sh
npm i
```

## Development

### Hot Building

While developing your resource, this boilerplate offers 
a `watch` script that will automatically hot rebuild on any
change within the `client` or `server` directories.

```sh
npm run watch
```
*This script still requires you restart the resource for the
changes to be reflected in-game*

## Production Build
Once you have completed the development phase of your resource,
you must create an optimized & minimized production build, using
the `build` script.

```sh
npm run build
```

We are using ESBuild as the primary bundler, which doesn't provide the option for automatic builds through the embedded FXServer webpack builder.
You will need to compile the resource yourself before providing to a server/customer.
