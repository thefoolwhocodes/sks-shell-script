echo `pwd`
cd `pwd`
git log --graph --decorate --date=short --pretty='format: %Cblue%h%Creset [%an %ad]%Cred%d %Cgreen%s%Creset' --abbrev-commit

