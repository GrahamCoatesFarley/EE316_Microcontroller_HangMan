from cmath import rect
from pickle import NONE
from GameFunctions import *
import pygame, os
from PIL import Image
import time


state = 8
Target = WordGen()
run = True
charList = ['a', 'b', 'c', 'd', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n']
inputchar = ''
index = 0
ans = ""
prevans = []
for i in Target:
    ans = ans + "_"
print(Target)
print(ans)

while(run):
    #inputchar = str(charList[index]).upper() #input char
    #print(char)
    if(state != 2 and state != 1 and state != 0 ):
        inputchar = str(input("enter char: ")).upper()



    if(state == 2): # Out of tries 
        print("out of tries")
        time.sleep(2)
        state = 1

    if(state == 1): # Game over hanndler 
        while(True):
            print("game over")
            inputchar = str(input("enter y/n : ")).upper()
            if(inputchar == 'Y'):
                state = 8
                Target = WordGen()
                ans = ""
                for i in Target:
                    ans = ans + "_"
                break
            elif(inputchar == 'N'):
                run = False
                break

    elif(state == 0): # You win state
        while(True):
            print("You win")
            inputchar = str(input("enter y/n : ")).upper()
            if(inputchar == 'Y'):   # Continue
                state = 8
                Target = WordGen()
                ans = ""
                for i in Target:
                    ans = ans + "_"
                break
            elif(inputchar == 'N'): # end
                run = False
                break
    else:
        try:
            prevans.index(inputchar) # checks if the char has already be used 
        except ValueError:
            #print("Entered expection")
            prevans.append(inputchar) # if the char is new then add to list
            #print(prevans)
            if(Target.find(inputchar) != -1): # if the char is contained in target
                ans_list = []
                Target_list = []
                for i in range(len(Target)):
                    if Target[i] == str(inputchar): # replaces the answer string index with char
                        Target_list = list(Target)
                        ans_list = list(ans)
                        ans_list[i] = Target_list[i]
                        anstemp = ""
                        for j in ans_list:
                            anstemp = anstemp + j
                        ans = anstemp
                if(ans == Target):
                    state = 0
            else:
                state = state - 1 # if not found decrease the state
                print("Not Found")
            #break
    print(ans)
    #index = index + 1
    print(state)

