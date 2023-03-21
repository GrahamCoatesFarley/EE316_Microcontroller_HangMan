# IMPORTANT: Install py games using: pip install pygame

#Imports 
from asyncio.windows_events import NULL
from GameFunctions import *
from tkinter import *
import multiprocessing as mp


if __name__ == '__main__':

    #Startup conditions 
    run = True
    char = NULL
    state = 9
    Target = NULL
    numgames = 0 
    numwins = 0
    prevans = []
    ans = ""
    
    # Sets up multiple cores 
    # = Process(UserDataTerminal)
    #GameProccess = Process(GameProcess)


    #Main run 
    while(run):
        # User input core 
        #UserData = mp.Process(target=UserDataTerminal, args=()) # NEED TO BE READ FROM UART 
        #GameProccess = mp.Process(target=GameProcess, args=())
       
        #UserData.start()
        #%UserData.join()
        char = UserDataTerminal()

        # data that needs to be retained from function
        (run, numgames, numwins, state, prevans, Target, ans) = GameProcess(char, state, numgames, numwins, prevans, Target, ans)
