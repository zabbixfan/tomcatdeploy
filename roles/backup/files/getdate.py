import os,sys
def getdir(path):
    dirs=[]
    for dir in os.listdir(path):
         if os.path.isdir(os.path.join(path,dir)):
             if dir != "latest":
                 dirs.append(dir)
    date=[dir[0:10] for dir in dirs]
    max = date[0]
    for i in date:
        if i > max:
            max = i
    lastdate=[d for d in dirs if d.startswith(max)]
    min = lastdate[0]
    for i in lastdate:
        if min > i:
            min = i
    print min
getdir(sys.argv[1])
