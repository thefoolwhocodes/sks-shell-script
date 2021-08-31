echo `pwd`
cd `pwd`
git fetch --prune origin
git reset --hard origin/develop
git clean -f -d

