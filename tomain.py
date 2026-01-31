import os

cmds = '''cd..
git add .
git commit -m "Harsha update"
git checkout main
git merge --no-ff organized
git push origin main
git checkout organized'''
for i in cmds.splitlines():
  os.system(i)




