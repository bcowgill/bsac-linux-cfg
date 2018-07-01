pnpm run clean:all
pnpm run clean

pnpm run node
pnpm run debug
pnpm run benchmark
pnpm run esall
pnpm run node:typescript
pnpm run debug:typescript

pnpm run build
pnpm run build:react
pnpm run build:vue
pnpm run build:typescript
pnpm run build:all
pnpm run build:benchmark
pnpm run build:esall

pnpm run test && pnpm run test:update
pnpm run test:debug
pnpm run coverage
pnpm run coverage:view

pnpm run browser
# manual tests:
#pnpm run start:benchmark # not working...
pnpm run start:all
pnpm run start:esall
pnpm run start:typescript
pnpm run start:vue
pnpm run start:react
pnpm run start
echo Finished
