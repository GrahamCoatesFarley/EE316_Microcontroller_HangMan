# IMPORTANT: Install py games using: pip install pygame
from asyncio.windows_events import NULL
import pygame, os
import random
from cmath import rect
import pygame, os
import time


#
def UserDataTerminal():
	char = input("Enter Char: ")
	strin = str(char)
	return strin.upper()

# Function that hanndles the back end 
def Backend(inputchar, state, numgames, numwins, prevans, Target, ans):
	run = True
	if(state == 9):
		prevans = []
		Target = WordGen()
		state = 8
		#state = state -1
		ans = ""
		for i in Target:
			ans = ans + "_"


	if(state == 2): # Out of tries 
		
		#REPLACE WITH SERIAL TRANSFER LATER
		print("out of tries")

		#REPLACE WITH SERIAL TRANSFER LATER
		numgames = numgames + 1
		state = 0
		print("Sorry! The correct word was", Target, ". You have solved ", numwins, " puzzles out of ", numgames)
		time.sleep(3)	

	elif(state == 1): # You win state
		numgames = numgames + 1
		numwins = numwins + 1
		print("Well done! You have solved ", numwins, "puzzles out of ", numgames)  
		print("Continue Y/N? ")

		if(inputchar == 'Y'):   # Continue
			state = 8
			Target = WordGen()
			ans = ""
			for i in Target:
				ans = ans + "_"
		elif(inputchar == 'N'): # end
			run = False

	elif(state == 0):
		if(inputchar == 'Y'):
			state = 8
			Target = WordGen()
			ans = ""
			for i in Target:
				ans = ans + "_"
		elif(inputchar == 'N'):
			run = False
	if state < 0:
		state = 9

	if(state != 2 and state != 1 and state != 0):
		try:
			prevans.index(inputchar) # checks if the char has already be used 
		except ValueError:
			#print("Entered expection)
			if(inputchar != NULL):
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
	return (state, Target, ans, run, numgames, numwins, prevans)

# Function that handles GUI 
def DisplayHandler(state, Target, ans):
	window_width = 1500
	window_height = 1000
	image_width = 960
	image_height = 720
	black = (0, 0, 0)
	white = (255, 255, 255)

	pygame.init() # intializes the pygame object

	screen = pygame.display.set_mode((window_width, window_height))
	#screen = pygame.display.toggle_fullscreen()
	screen.fill(white)   # Fill the background colour to the screen
	pygame.display.set_caption('Game Window') # Set the caption of the screen

	if state == 8:
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

	elif state == 7:
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

	elif state == 6:
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

	elif state == 5: 
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

	elif state == 4: 
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

	elif state == 3: 
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

	elif state == 2: 
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

		pygame.display.flip()# Update the display using flip
		time.sleep(2)
		state = 1
	
	if state == 1:
		#Resets Screen
		screen = pygame.display.set_mode((window_width, window_height))
		#screen = pygame.display.toggle_fullscreen()
		screen.fill(white)   # Fill the background colour to the screen

		#Prints Fail Screen
		(x1,y1) = window_width // 2, window_height // 4
		DisplayText(screen, "Game Over: Answer is ", black, x1, y1)
		y1 = y1 + 100
		DisplayText(screen, Target, black, x1, y1)
		y1 = y1 + 100
		DisplayText(screen, "Continue Y/N", black, x1, y1)

	elif state == 0:
		# Resets screen
		screen = pygame.display.set_mode((window_width, window_height))
		#screen = pygame.display.toggle_fullscreen()
		screen.fill(white)   # Fill the background colour to the screen

		#Prints message
		(x1,y1) = window_width // 2, window_height // 4
		DisplayText(screen, "You Win!!!", black, x1, y1)
		y1 = y1 + 100
		DisplayText(screen, "Continue Y/N", black, x1, y1)


	pygame.display.flip()# Update the display using flip

	# waiting for exit game event 
	for event in pygame.event.get():

		# Check for QUIT event      
		if event.type == pygame.QUIT:
			return False

# Core that hanndles both the backend and GUI
def GameProcess(inputchar, state, numgames, numwins, prevans, Target, ans):
	if state == 9:
		prevans = []
	(state, Target, ans, run, numgames, numwins, prevans) = Backend(inputchar, state, numgames, numwins, prevans, Target, ans)
	print(state)
	DisplayHandler(state, Target, ans)
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
	Wordlist = ["Disproportional", "Night", "Engineering", "Intresting", "Python", "Program", "Europe", "Clarkson"]
	choice = str(random.choice(Wordlist))
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
