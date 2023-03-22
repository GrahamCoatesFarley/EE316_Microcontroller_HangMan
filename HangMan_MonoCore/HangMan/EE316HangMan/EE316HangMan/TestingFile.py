from cmath import rect
from pickle import NONE
from GameFunctions import *
import pygame, os
from PIL import Image
import time

#print(WordGen()) #test word gen

# Test window generation and alterations 

# GAME WINDOW TEST #############################################
os.environ['SDL_VIDEO_CENTERED'] = '1' # You have to call this before pygame.init()

#pygame.init() # intializes the pygame object

	#info = pygame.display.Info() # You have to call this before pygame.display.set_mode()
	#screen_width,screen_height = info.current_w,info.current_h
	#window_width,window_height = screen_width-10,screen_height-50

	# Define the background colour
	# using RGB color coding.  
black = (0, 0, 0)
white = (255, 255, 255)
  
	# Define the dimensions of
	# screen object(width,height)
	#screen = pygame.display.set_mode(window_width, window_height)#, pygame.FULLSCREEN())
window_width = 1500
window_height = 1000

#screen = pygame.display.set_mode((window_width, window_height))
#screen = pygame.display.toggle_fullscreen()

#screen.fill(background_colour)   # Fill the background colour to the screen
	
#pygame.display.set_caption('Game Window') # Set the caption of the screen
	
#pygame.display.flip() # Update the display using flip
  
image = 'Noose.png' # image dimensions 960 x 720
image_width = 960
image_height = 720

#image = 'D:\Python Programs\HangMan\EE316HangMan\EE316HangMan\LegBoth.png'

#imp = pygame.image.load(image) # Loads image 

(x,y) = ((window_width-image_width)/2 , 150) ##Print location

#pygame.Surface.blit(screen, imp, (x, y)) # Loads to the window   
#pygame.display.flip()# Update the display using flip

running = True# Variable to keep our game loop running

Target = WordGen()
ans = Target
			
# Define the dimensions of            
window_width = 1500
window_height = 1000
state = 8

while running:# game loop
# for loop through the event queue  
	if state == 8:
		pygame.init() # intializes the pygame object

		screen = pygame.display.set_mode((window_width, window_height))
		#screen = pygame.display.toggle_fullscreen()
		screen.fill(white)   # Fill the background colour to the screen
		pygame.display.set_caption('Game Window') # Set the caption of the screen


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
	
	elif state == 1:
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
	
	 # walks through the different states 
	time.sleep(3)
	state = state - 1
	if state == -1:
		state = 8


	# waiting for exit game event 
	for event in pygame.event.get():

		# Check for QUIT event      
		if event.type == pygame.QUIT:
			running = False