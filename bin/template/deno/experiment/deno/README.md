2024 Jan
Getting started with deno:

https://docs.deno.com/runtime/manual/

```
curl -fsSL https://deno.land/install.sh > install.sh
chmod +x install.sh
./install.sh

or ...
brew install deno
```

```
br388313@C02FJ2JKMD6M deno % ./install.sh
##########################################################################
100.0% Archive: /Users/br388313/.deno/bin/deno.zip inflating:
/Users/br388313/.deno/bin/deno\
Deno was installed successfully to /Users/br388313/.deno/bin/deno Manually add
the directory to your $HOME/.zshrc (or similar) export
DENO_INSTALL="/Users/br388313/.deno" export PATH="$DENO_INSTALL/bin:$PATH" Run
'/Users/br388313/.deno/bin/deno --help' to get started

Stuck? Join our Discord https://discord.gg/deno br388313@C02FJ2JKMD6M deno %
```

deno --help > deno.help.txt

deno --version

```
deno 1.39.2 (release, x86_64-apple-darwin) 
v8 12.0.267.8
typescript 5.3.3
```

You can maintain different versions:

```
cd ~ mv .deno .deno-1.39.2
ln -s .deno-1.39.2 .deno 
tar cvzf deno-1.39.2.tgz .deno-1.39.2
```

Then to upgrade to a new version:

```
deno upgrade
deno upgrade --version 1.0.1
```

```
br388313@C02FJ2JKMD6M deno % deno info DENO_DIR location:
/Users/br388313/experiment/deno/./.deno-cache Remote modules cache:
/Users/br388313/experiment/deno/./.deno-cache/deps npm modules cache:
/Users/br388313/experiment/deno/./.deno-cache/npm Emitted modules cache:
/Users/br388313/experiment/deno/./.deno-cache/gen Language server registries
cache: /Users/br388313/experiment/deno/./.deno-cache/registries Origin storage:
/Users/br388313/experiment/deno/./.deno-cache/location_data
```

create www.ts with shebang line to run it.

```
#!/usr/bin/env deno run --allow-net
or #!/usr/bin/env deno run -A
```

without the --allow-net option the script will prompt for user confirmationn
before making network accesses

the -A flag allows ALL runtime accesses (like file system, environment varibles,
etc, not just network access.)

chmod +x www.ts; ./www.ts

TODO deploy it to DenoDeploy

See Host your server on Deno Deploy (optional) at

https://docs.deno.com/runtime/manual/

```
deno lint

deno fmt

deno check *.ts *.js

deno test

deno test --watch
deno lint --watch
deno fmt --watch

deno task dev   # runs the command in tasks section of deno.jsonc

deno types > deno.types.d  # spits out TypeScript types for deno itself
```

Next steps

We've only just scratched the surface of what's possible with the Deno runtime.
Here are a few topics you might want to explore next.

Take a tour of key Deno features
https://docs.deno.com/runtime/manual/getting_started/first_steps

Learn how to use ECMAScript modules
https://docs.deno.com/runtime/manual/basics/modules/

Compatibility with Node.js and npm

https://docs.deno.com/runtime/manual/node/

Web platform APIs available in Deno
https://docs.deno.com/runtime/manual/runtime/web_platform_apis

Deno namespace built-in APIs
https://docs.deno.com/runtime/manual/runtime/builtin_apis

CLI command reference

https://docs.deno.com/runtime/manual/tools/

Getting help

https://docs.deno.com/runtime/manual/help

You can learn more about using TypeScript in Deno here.
https://docs.deno.com/runtime/manual/advanced/typescript/overview

Deno's full suite of configurable runtime security options.
https://docs.deno.com/runtime/manual/basics/permissions

Deno provides a built-in test runner, which uses an assertion module distributed
via HTTPS URL.

https://docs.deno.com/runtime/manual/basics/testing/

There's much more to explore with the standard library

https://deno.land/std

and third-party modules - be sure to check them out!

https://deno.land/x

Learn more about configuring your project here.
https://docs.deno.com/runtime/manual/getting_started/configuration_file

Set up your dev environment - learn about options for configuring your local dev
environment
https://docs.deno.com/runtime/manual/getting_started/setup_your_environment

Tutorials and Examples - Sample code and use cases for Deno
https://docs.deno.com/runtime/tutorials/

Deno by Example - Code snippets to learn Deno by example
https://examples.deno.land/

The Deno standard library has a std/flags module for parsing command line arguments.
https://deno.land/std/flags/mod.ts

For a complete list of supported rules visit the deno_lint rule documentation.
https://lint.deno.land/

Deno files:

~/.deno/bin/deno

./deno.jsonc - like package.json for deno

./deno.lock - like npm or yarn package lock file

$DENO_DIR -- $HOME/Library/Caches/deno - MacOS deno cached packages

./.deno-cache - My configured location for the deno package cache actually use
../deno-packages

with ln -s ../deno-packages .deno-cache so that deno lint and deno fmt commands

will not descend into the package cache

Deno in production:

--cached-only Require that remote dependencies are already cached

NOTES:

deno run -A # is more permissive than:

deno run --allow-net but not documented in deno --help

So far, we've been running all of our scripts with the -A flag, which grants all
runtime feature access to our scripts. This is the most permissive mode to run a
Deno program, but usually you'll want to grant your code only the permissions it
needs to run.
