npm run build
cd ../memory-verses-gh-pages
rm *.js
rm *.css
cp -r ../memory-verses/dist/ .
git add .
git commit -m 'syncing with memory verses repo'
git push origin gh-pages
