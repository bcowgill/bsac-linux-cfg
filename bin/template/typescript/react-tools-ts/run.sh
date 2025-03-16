echo tsx:
./tsrunner.ts 2>&1 | grep total
echo deno:
deno ./tsrunner.ts 2>&1 | grep total
echo bun:
bun ./tsrunner.ts 2>&1 | grep total
cp tsrunner.ts /tmp
echo you need to:
echo node /tmp/tsrunner.ts
echo from ubuntu user termnial with node v23.9.0

git config --global user.email "968686+bcowgill@users.noreply.github.com"
git config --global user.name "Brent S.A. Cowgill"
