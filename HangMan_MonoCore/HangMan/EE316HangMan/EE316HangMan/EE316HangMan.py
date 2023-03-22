# IMPORTANT: Install py games using: pip install pygame

#Imports 
from asyncio.windows_events import NULL
from GameFunctions import *
from tkinter import *
import multiprocessing as mp
import serial
from threading import Thread

if __name__ == '__main__':

	#Startup conditions 
	run = True
	char = NULL
	state = 10
	Target = NULL
	numgames = 0 
	numwins = 0
	prevans = []
	ans = ""
	port = GetPort()
	ser = serial.Serial(port, 115200, timeout= None)# Sets up the serial com 
	
	# Sets up multiple cores 
	# = Process(UserDataTerminal)
	#GameProccess = Process(GameProcess)


	#Window init
	window_width = 1500
	window_height = 1000
	image_width = 960
	image_height = 720

	pygame.init() # intializes the pygame object
	black = (0, 0, 0)
	white = (255, 255, 255)
	screen = pygame.display.set_mode((window_width, window_height))
	#screen = pygame.display.toggle_fullscreen()
	screen.fill(white)   # Fill the background colour to the screen
	pygame.display.set_caption('Game Window') # Set the caption of the screen

	imp = pygame.image.load('Noose.png') # Loads image 
	(x,y) = ((window_width-image_width)/2 , 150) # Print location
	imageRect = pygame.Rect(x,y , image_width, image_height)
	pygame.Surface.blit(screen, imp, (x, y)) # Loads to the window

	(x,y) = window_width // 2, window_height // (8/7)
	DisplayText(screen, "NEW GAME?", black, x, y)

	pygame.display.flip()# Update the display using flip

	SendDataSerial(ser, "New Game?")
	while(True):
		inputchar = UserDataSerial(ser)
		if(inputchar == 'Y'):# Continue
			state = 10
			break
		elif(inputchar == 'N'):# end
			print("No Pressed")
			run = False
			break




	#Main run 
	while(run):
		# data that needs to be retained from function
		(run, numgames, numwins, state, prevans, Target, ans) = GameProcess(char, state, numgames, numwins, prevans, Target, ans, ser, pygame, screen)
		if(state != 2 and state != 1 and state != 0 and state != 10):
			char = UserDataSerial(ser)
		# waiting for exit game event 
		for event in pygame.event.get():

		# Check for QUIT event      
			if event.type == pygame.QUIT:
				run = False

string = str(numwins) + " correct of " +  str(numgames)
print(string)
SendDataSerial(ser, string)
time.sleep(4)
SendDataSerial(ser, "Game Over")
ser.close()