#!/bin/bash


case $1 in
    *"- [ ] "* ) 
        # echo "got - [ ]"
        echo $1 | sed -e 's/- \[ \] /- \[x\] ~~/g' | awk '{print $0"~~"}' | tr -d "\n" ;;
    *"- [x] "* ) 
        # echo "got - [x]"
        echo $1 | sed -e 's/- \[x] ~~/- \[ \] /g' | sed -e 's/~~//g' | tr -d "\n" ;;
    *"- "*) 
        # echo "got other text"
        echo $1 | sed -e 's/- /- \[ \] /g' | tr -d "\n" ;;
esac

