import os

cmds = '''cd..
git checkout main
git pull origin main
git checkout v12
git merge main'''
for i in cmds.splitlines():
  os.system(i)
  