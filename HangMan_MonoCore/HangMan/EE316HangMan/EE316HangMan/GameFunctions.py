# IMPORTANT: Install py games using: pip install pygame
from asyncio.windows_events import NULL
import pygame, os
import random
from cmath import rect
import pygame, os
import time
state = 10

# Gets data from ternminal
def UserDataTerminal():
	char = input("Enter Char: ")
	strin = str(char)
	return strin.upper()

# Get serial port
def GetPort():
	port = input("Input COM port: ")
	return port


# Receives serial data 
def UserDataSerial(ser):
	data = ser.read().decode("ascii") # waits for char
	char = str(data)
	return char.upper()
	

# Send data as a serial message 
def SendDataSerial(ser, message):
		
	if len(message) <= 16: # checks if message fits on LCD 16x2
		message = message + (16-len(message))*" " # adds spaces to end
		ser.write(message.encode())	#sends data
	else:	#if data needs to scroll scroll on LCD
		for i in message:# Loops through the message
			ser.write(i.encode())	#sends data
			time.sleep(.4)


# Sends data to Seven Seg
def SendDataSevenSeg(ser, num):
	number = num + 128
	bytenum = number.to_bytes(1, "big")
	ser.write(bytenum)	#sends data
	time.sleep(1.5)

# Function that hanndles the back end 
def Backend(inputchar, state, numgames, numwins, prevans, Target, ans, ser):
	run = True
	
	#if(state == 2 or state == 1):
	#	state = 0

	if(10> state > 2):
		try:
			print("Target_list len:" + str(len(Target))+ " Ans_list len:" + str(len(ans)))

			if(inputchar != NULL and inputchar != None):
				prevans.index(inputchar) # checks if the char has already be used 
		except ValueError:
			#if(inputchar != NULL and inputchar != None):
			prevans.append(inputchar) # if the char is new then add to list
			if(Target.find(inputchar) != -1): # if the char is contained in target
				Target_list = []
				ans_list = []
				Target_list = list(Target)
				ans_list = list(ans)
				for i in range(len(Target)):
					if Target[i] == str(inputchar): # replaces the answer string index with char
						ans_list[i] = Target_list[i]
					anstemp = ""
					for j in ans_list:
						anstemp = anstemp + j
					ans = anstemp
					#SendDataSerial(ser, ans)
				if(ans == Target):
					state = 1
					#SendDataSerial(ser, Target)
			else:
				print("-1")
				state = state - 1 # if not found decrease the state

		SendDataSerial(ser, ans)


	if(state == 10):
		SendDataSerial(ser, "New Game")
		time.sleep(.8)
		prevans = []
		Target = WordGen()
		state = 9
		ans = ""
		for i in Target:
			ans = ans + "_"
		SendDataSerial(ser, ans)
		SendDataSevenSeg(ser, 6)

	if(state == 0):
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

		else:
			state = 0

	if(state == 2): # Out of tries 
		numgames = numgames + 1
		#string = str("Sorry! The correct word was " + Target + ". You have solved " + str(numwins) + " puzzles out of " + str(numgames))
		#SendDataSerial(ser, string)
		#state = 0	

	elif(state == 1): # You win state
		numgames = numgames + 1
		numwins = numwins + 1
		#string = str("Well done! You have solved " + str(numwins) + " puzzles out of " +  str(numgames))  
		#print("Continue Y/N? ")
		#SendDataSerial(ser, string)
		#state = 0



	if state < 0:
		state = 10

	
	return (state, Target, ans, run, numgames, numwins, prevans)

# Function that handles GUI 
def DisplayHandler(state, Target, ans, ser, pygame, screen, numgames, numwins):
	
	window_width = 1500
	window_height = 1000
	image_width = 960
	image_height = 720
	black = (0, 0, 0)
	white = (255, 255, 255)


	pygame.init() # intializes the pygame object
	black = (0, 0, 0)
	white = (255, 255, 255)
	screen = pygame.display.set_mode((window_width, window_height))
	#screen = pygame.display.toggle_fullscreen()
	screen.fill(white)   # Fill the background colour to the screen
	pygame.display.set_caption('Game Window') # Set the caption of the screen
	
	print("IN GUI hanndler")
	#pygame.display.flip()# Update the display using flip


	if state == 9:
		imp = pygame.image.load('Noose.png') # Loads image 
		(x,y) = ((window_width-image_width)/2 , 150) # Print location
		imageRect = pygame.Rect(x,y , image_width, image_height)
		pygame.Surface.blit(screen, imp, (x, y)) # Loads to the window

		#Display word
		(x,y) = window_width // 2, window_height // (8/7)
		DisplayText(screen, ans, black, x, y)

		#Sets up display counter
		(x1,y1) = window_width // (9/7), window_height // 4
		DisplayText(screen, "Counter", black, x1, y1)

		#Destplays count
		(x2,y2) = (x1, y1+100)
		DisplayText(screen, "6", black, x2, y2)
		pygame.display.flip()# Update the display using flip


		SendDataSevenSeg(ser, 6) # prints to seven seg
		SendDataSerial(ser, ans)

	elif state == 8:
		#screen = pygame.display.set_mode((window_width, window_height))
		imp = pygame.image.load('Head.png') # Loads image 
		(x,y) = ((window_width-image_width)/2 , 150) ##Print location
		pygame.Surface.blit(screen, imp, (x, y)) # Loads to the window

		#Display word
		(x,y) = window_width // 2, window_height // (8/7)
		DisplayText(screen, ans, black, x, y)

		#Sets up display counter
		(x1,y1) = window_width // (9/7), window_height // 4
		DisplayText(screen, "Counter", black, x1, y1)

		#Destplays count
		(x2,y2) = (x1, y1+100)
		DisplayText(screen, "5", black, x2, y2)
		pygame.display.flip()# Update the display using flip

		SendDataSevenSeg(ser, 5) # prints to seven seg


	elif state == 7:
		imp = pygame.image.load('Body.png') # Loads image 
		(x,y) = ((window_width-image_width)/2 , 150) ##Print location
		pygame.Surface.blit(screen, imp, (x, y)) # Loads to the window

		#Display word
		(x,y) = window_width // 2, window_height // (8/7)
		DisplayText(screen, ans, black, x, y)

		#Sets up display counter
		(x1,y1) = window_width // (9/7), window_height // 4
		DisplayText(screen, "Counter", black, x1, y1)

		#Destplays count
		(x2,y2) = (x1, y1+100)
		DisplayText(screen, "4", black, x2, y2)
		pygame.display.flip()# Update the display using flip

		SendDataSevenSeg(ser, 4) # prints to seven seg


	elif state == 6: 
		imp = pygame.image.load('HandR.png') # Loads image 
		(x,y) = ((window_width-image_width)/2 , 150) ##Print location
		pygame.Surface.blit(screen, imp, (x, y)) # Loads to the window

		#Display word
		(x,y) = window_width // 2, window_height // (8/7)
		DisplayText(screen, ans, black, x, y)

		#Sets up display counter
		(x1,y1) = window_width // (9/7), window_height // 4
		DisplayText(screen, "Counter", black, x1, y1)

		#Destplays count
		(x2,y2) = (x1, y1+100)
		DisplayText(screen, "3", black, x2, y2)
		pygame.display.flip()# Update the display using flip

		SendDataSevenSeg(ser, 3) # prints to seven seg

	elif state == 5: 
		imp = pygame.image.load('HandBoth.png') # Loads image 
		(x,y) = ((window_width-image_width)/2 , 150) ##Print location
		pygame.Surface.blit(screen, imp, (x, y)) # Loads to the window

		#Display word
		(x,y) = window_width // 2, window_height // (8/7)
		DisplayText(screen, ans, black, x, y)

		#Sets up display counter
		(x1,y1) = window_width // (9/7), window_height // 4
		DisplayText(screen, "Counter", black, x1, y1)

		#Destplays count
		(x2,y2) = (x1, y1+100)
		DisplayText(screen, "2", black, x2, y2)
		pygame.display.flip()# Update the display using flip

		SendDataSevenSeg(ser, 2) # prints to seven seg

	elif state == 4: 
		imp = pygame.image.load('LegR.png') # Loads image 
		(x,y) = ((window_width-image_width)/2 , 150) ##Print location
		pygame.Surface.blit(screen, imp, (x, y)) # Loads to the window

		#Display word
		(x,y) = window_width // 2, window_height // (8/7)
		DisplayText(screen, ans, black, x, y)

		#Sets up display counter
		(x1,y1) = window_width // (9/7), window_height // 4
		DisplayText(screen, "Counter", black, x1, y1)

		#Destplays count
		(x2,y2) = (x1, y1+100)
		DisplayText(screen, "1", black, x2, y2)
		pygame.display.flip()# Update the display using flip

		
		SendDataSevenSeg(ser, 1) # prints to seven seg


	elif state == 3: 
		imp = pygame.image.load('LegBoth.png') # Loads image 
		(x,y) = ((window_width-image_width)/2 , 150) ##Print location
		pygame.Surface.blit(screen, imp, (x, y)) # Loads to the window

		#Display word
		(x,y) = window_width // 2, window_height // (8/7)
		DisplayText(screen, ans, black, x, y)

		#Sets up display counter
		(x1,y1) = window_width // (9/7), window_height // 4
		DisplayText(screen, "Counter", black, x1, y1)

		#Destplays count
		(x2,y2) = (x1, y1+100)
		DisplayText(screen, "0", black, x2, y2)
		SendDataSevenSeg(ser, 0) # prints to seven seg

		pygame.display.flip()# Update the display using flip
		time.sleep(2)
		state = 2
	
	if state == 2:
		#Resets Screen
		screen = pygame.display.set_mode((window_width, window_height))
		#screen = pygame.display.toggle_fullscreen()
		screen.fill(white)   # Fill the background colour to the screen

		#Prints Fail Screen
		(x1,y1) = window_width // 2, window_height // 4
		DisplayText(screen, "Game Over: Answer is ", black, x1, y1)
		y1 = y1 + 100
		DisplayText(screen, Target, black, x1, y1)
		pygame.display.flip()# Update the display using flip

		SendDataSevenSeg(ser, 0) # prints to seven seg
		#SendDataSerial(ser, Target)
		#time.sleep(.8)
		pygame.display.flip()# Update the display using flip

		numgames = numgames + 1
		string = str("Sorry! The correct word was " + Target + ". You have solved " + str(numwins) + " puzzles out of " + str(numgames))
		
		SendDataSerial(ser, string)

		time.sleep(2)
		print("in state 2 GUI")
		state = 0
		#SendDataSerial(ser, "New Game?")

	if state == 1:
		SendDataSevenSeg(ser, 0) # prints to seven seg

		# Resets screen
		screen = pygame.display.set_mode((window_width, window_height))
		#screen = pygame.display.toggle_fullscreen()
		screen.fill(white)   # Fill the background colour to the screen

		#Prints message
		(x1,y1) = window_width // 2, window_height // 4
		DisplayText(screen, "You Win!!!", black, x1, y1)
		pygame.display.flip()# Update the display using flip

		SendDataSerial(ser, Target)
		time.sleep(.8)

		string = str("Well done! You have solved " + str(numwins) + " puzzles out of " +  str(numgames))  
		#print("Continue Y/N? ")
		SendDataSerial(ser, string)
		time.sleep(2)
		state = 0


	if state == 0:
		(x,y) = (window_width/2 , 150) ##Print location
		#y1 = y1 + 100
		DisplayText(screen, "Continue? Y/N", black, x, y)
		pygame.display.flip()# Update the display using flip
		SendDataSerial(ser, "New Game?")
	pygame.display.flip()# Update the display using flip

	return (state, numgames, numwins)

# Core that hanndles both the backend and GUI
def GameProcess(inputchar, state, numgames, numwins, prevans, Target, ans, ser, pygame, screen):
	(state, Target, ans, run, numgames, numwins, prevans) = Backend(inputchar, state, numgames, numwins, prevans, Target, ans, ser)
	print(state)
	(state, numgames, numwins) = DisplayHandler(state, Target, ans, ser, pygame, screen, numgames, numwins)
	return (run, numgames, numwins, state, prevans, Target, ans)


def DisplayImage(pygame, image, x, y):
	screen = pygame.display
	imp = pygame.image.load(image)
	pygame.Surface.blit(screen, imp, (x, y)) # Loads to the window

def DisplayText(screen, String, Color, x, y):
	# Sets up display text
	font = pygame.font.Font('freesansbold.ttf', 100) # Sets font
	text = font.render(String, True, Color, (255, 255, 255)) # Makes text
	textRect = text.get_rect() # Makes text object
	textRect.center = (x, y) # location of text center
	screen.blit(text, textRect) # Prints text

# Generates a random word from predefinded list 
def WordGen():
	f = open("wordlist.txt", "r")
	Wordlist = f.read().split()
	choice = str(random.choice(Wordlist))
	f.close()
	return choice.upper()

def MakePygame():
	os.environ['SDL_VIDEO_CENTERED'] = '1' # You have to call this before pygame.init()

	pygame.init()

	#info = pygame.display.Info() # You have to call this before pygame.display.set_mode()
	#screen_width,screen_height = info.current_w,info.current_h
	#window_width,window_height = screen_width-10,screen_height-50

	# Define the background colour
	# using RGB color coding.  
	background_colour = (255, 255, 255)
  
	# Define the dimensions of
	# screen object(width,height)
	#screen = pygame.display.set_mode(window_width, window_height)#, pygame.FULLSCREEN())
	
	screen = pygame.display.set_mode((1500, 1000))#, pygame.FULLSCREEN())
 
	screen.fill(background_colour)
	# Set the caption of the screen
	pygame.display.set_caption('Game Window')
  
	# Fill the background colour to the screen
  
	# Update the display using flip
	pygame.display.flip()
	return pygame
