#                      _..._                 .           __.....__
#                    .'     '.             .'|       .-''         '.
#                   .   .-.   .          .'  |      /     .-''"'-.  `.
#                   |  '   '  |    __   <    |     /     /________\   \
#               _   |  |   |  | .:--.'.  |   | ____|                  |
#             .' |  |  |   |  |/ |   \ | |   | \ .'\    .-------------'
#            .   | /|  |   |  |`" __ | | |   |/  .  \    '-.____...---.
#          .'.'| |//|  |   |  | .'.''| | |    /\  \  `.             .'
#        .'.'.-'  / |  |   |  |/ /   | |_|   |  \  \   `''-...... -'
#        .'   \_.'  |  |   |  |\ \._,\ '/'    \  \  \
#                   '--'   '--' `--'  `"'------'  '---'
#
#
#
#                                               .......
#                                     ..  ...';:ccc::,;,'.
#                                 ..'':cc;;;::::;;:::,'',,,.
#                              .:;c,'clkkxdlol::l;,.......',,
#                          ::;;cok0Ox00xdl:''..;'..........';;
#                          o0lcddxoloc'.,. .;,,'.............,'
#                           ,'.,cc'..  .;..;o,.       .......''.
#                             :  ;     lccxl'          .......'.
#                             .  .    oooo,.            ......',.
#                                    cdl;'.             .......,.
#                                 .;dl,..                ......,,
#                                 ;,.                   .......,;
#                                                        ......',
#                                                       .......,;
#                                                       ......';'
#                                                      .......,:.
#                                                     .......';,
#                                                   ........';:
#                                                 ........',;:.
#                                             ..'.......',;::.
#                                         ..';;,'......',:c:.
#                                       .;lcc:;'.....',:c:.
#                                     .coooc;,.....,;:c;.
#                                   .:ddol,....',;:;,.
#                                  'cddl:'...,;:'.
#                                 ,odoc;..',;;.                    ,.
#                                ,odo:,..';:.                     .;
#                               'ldo:,..';'                       .;.
#                              .cxxl,'.';,                        .;'
#                              ,odl;'.',c.                         ;,.
#                              :odc'..,;;                          .;,'
#                              coo:'.',:,                           ';,'
#                              lll:...';,                            ,,''
#                              :lo:'...,;         ...''''.....       .;,''
#                              ,ooc;'..','..';:ccccccccccc::;;;.      .;''.
#          .;clooc:;:;''.......,lll:,....,:::;;,,''.....''..',,;,'     ,;',
#       .:oolc:::c:;::cllclcl::;cllc:'....';;,''...........',,;,',,    .;''.
#      .:ooc;''''''''''''''''''',cccc:'......'',,,,,,,,,,;;;;;;'',:.   .;''.
#      ;:oxoc:,'''............''';::::;'''''........'''',,,'...',,:.   .;,',
#     .'';loolcc::::c:::::;;;;;,;::;;::;,;;,,,,,''''...........',;c.   ';,':
#     .'..',;;::,,,,;,'',,,;;;;;;,;,,','''...,,'''',,,''........';l.  .;,.';
#    .,,'.............,;::::,'''...................',,,;,.........'...''..;;
#   ;c;',,'........,:cc:;'........................''',,,'....','..',::...'c'
#  ':od;'.......':lc;,'................''''''''''''''....',,:;,'..',cl'.':o.
#  :;;cclc:,;;:::;''................................'',;;:c:;,'...';cc'';c,
#  ;'''',;;;;,,'............''...........',,,'',,,;:::c::;;'.....',cl;';:.
#  .'....................'............',;;::::;;:::;;;;,'.......';loc.'.
#   '.................''.............'',,,,,,,,,'''''.........',:ll.
#    .'........''''''.   ..................................',;;:;.
#      ...''''....          ..........................'',,;;:;.
#                                ....''''''''''''''',,;;:,'.
#                                    ......'',,'','''..
#


################################################################################
#                  Fonctions d'affichage et d'entrée clavier                   #
################################################################################

# Ces fonctions s'occupent de l'affichage et des entrées clavier.  
# Il n'est pas nécessaire de les modifier.!!!

#Fiche technique : avoir un clavier avec les touches z q s d inverse :-)
#Fiche technique bis : avoir les yeux a l'envers avec l'axe des x et y inverse :D (on vous adore quand meme)
#Fiche technique bis bis (bis bis : plus complique qu'un pointeur de pointeur "c'est faux") : mars ne prend pas en compte les accents,
#								soyez indulgent :P


.data

# Tampon d'affichage du jeu 256*256 de manière linéaire.

frameBuffer: .word 0 : 1024  # Frame buffer

# Code couleur pour l'affichage
# Codage des couleurs 0xwwxxyyzz où
#   ww = 00
#   00 <= xx <= ff est la couleur rouge en hexadécimal
#   00 <= yy <= ff est la couleur verte en hexadécimal
#   00 <= zz <= ff est la couleur bleue en hexadécimal

colors: .word 0x00000000, 0x00ff0000, 0xff00ff00, 0x00396239, 0x00ff00ff
.eqv black 0
.eqv red   4
.eqv green 8
.eqv greenV2  12
.eqv rose  16

#creation du mot multicolor pour le changement de la couleurs des cases du serpent
multicolor: .word 0x12F34F, 0x00FF00, 0x0F504F, 0xFFFF00, 0xF3F2FF, 0x00FFFF, 0x800080, 0xFFA500, 0xFFC0CB, 0x008000, 0x000080, 0x800000, 0x008080, 0xA52A2A, 0xFFD700, 0x4B0082 

# Dernière position connue de la queue du serpent.

lastSnakePiece: .word 0, 0

.text
j main

############################# printColorAtPosition #############################
# Paramètres: $a0 La valeur de la couleur
#             $a1 La position en X
#             $a2 La position en Y
# Retour: Aucun
# Effet de bord: Modifie l'affichage du jeu
################################################################################

printColorAtPosition:
lw $t0 tailleGrille
mul $t0 $a1 $t0
add $t0 $t0 $a2
sll $t0 $t0 2
sw $a0 frameBuffer($t0)
jr $ra

################################ resetAffichage ################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Réinitialise tout l'affichage avec la couleur noir
################################################################################

resetAffichage:
lw $t1 tailleGrille
mul $t1 $t1 $t1
sll $t1 $t1 2
la $t0 frameBuffer
addu $t1 $t0 $t1
lw $t3 colors + black

RALoop2: bge $t0 $t1 endRALoop2
  sw $t3 0($t0)
  add $t0 $t0 4
  j RALoop2
endRALoop2:
jr $ra

################################## printSnake ##################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Change la couleur de l'affichage aux emplacement ou se
#                trouve le serpent et sauvegarde la dernière position connue de
#                la queue du serpent.
################################################################################

printSnake:
subu $sp $sp 12
sw $ra 0($sp)
sw $s0 4($sp)
sw $s1 8($sp)

lw $s0 tailleSnake
sll $s0 $s0 2
li $s1 0

lw $a0 colors + greenV2
lw $a1 snakePosX($s1)
lw $a2 snakePosY($s1)
jal printColorAtPosition
li $s1 4
li $t4 0
PSLoop:
bge $s1 $s0 endPSLoop
  li $t3 119			#============#
  and $t2, $s1, $t3		#Modulo de s1 par 119 pour ne pas dépasser du word multicolor
  lw $a0 multicolor($t4)	#Assignation de la couleur à la case
  lw $a1 snakePosX($s1)		
  lw $a2 snakePosY($s1)		
  jal printColorAtPosition
  addu $s1 $s1 4
  addi $t4 $t4 8
  j PSLoop
endPSLoop:

subu $s0 $s0 4
lw $t0 snakePosX($s0)
lw $t1 snakePosY($s0)
sw $t0 lastSnakePiece
sw $t1 lastSnakePiece + 4

lw $ra 0($sp)
lw $s0 4($sp)
lw $s1 8($sp)
addu $sp $sp 12
jr $ra

################################ printObstacles ################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Change la couleur de l'affichage aux emplacement des obstacles.
################################################################################

printObstacles:
subu $sp $sp 12
sw $ra 0($sp)
sw $s0 4($sp)
sw $s1 8($sp)

lw $s0 numObstacles
sll $s0 $s0 2
li $s1 0

POLoop:
bge $s1 $s0 endPOLoop
  lw $a0 colors + red
  lw $a1 obstaclesPosX($s1)
  lw $a2 obstaclesPosY($s1)
  jal printColorAtPosition
  addu $s1 $s1 4
  j POLoop
endPOLoop:

lw $ra 0($sp)
lw $s0 4($sp)
lw $s1 8($sp)
addu $sp $sp 12
jr $ra

################################## printCandy ##################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Change la couleur de l'affichage à l'emplacement du bonbon.
################################################################################

printCandy:
subu $sp $sp 4
sw $ra ($sp)

lw $a0 colors + rose
lw $a1 candy
lw $a2 candy + 4
jal printColorAtPosition

lw $ra ($sp)
addu $sp $sp 4
jr $ra

eraseLastSnakePiece:
subu $sp $sp 4
sw $ra ($sp)

lw $a0 colors + black
lw $a1 lastSnakePiece
lw $a2 lastSnakePiece + 4
jal printColorAtPosition

lw $ra ($sp)
addu $sp $sp 4
jr $ra

################################## printGame ###################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Effectue l'affichage de la totalité des éléments du jeu.
################################################################################

printGame:
subu $sp $sp 4
sw $ra 0($sp)

jal eraseLastSnakePiece
jal printSnake
jal printObstacles
jal printCandy

lw $ra 0($sp)
addu $sp $sp 4
jr $ra

############################## getRandomExcluding ##############################
# Paramètres: $a0 Un entier x | 0 <= x < tailleGrille
# Retour: $v0 Un entier y | 0 <= y < tailleGrille, y != x
################################################################################

getRandomExcluding:
move $t0 $a0
lw $a1 tailleGrille
li $v0 42
syscall
beq $t0 $a0 getRandomExcluding
move $v0 $a0
jr $ra

########################### newRandomObjectPosition ############################
# Description: Renvoie une position aléatoire sur un emplacement non utilisé
#              qui ne se trouve pas devant le serpent.
# Paramètres: Aucun
# Retour: $v0 Position X du nouvel objet
#         $v1 Position Y du nouvel objet
################################################################################

newRandomObjectPosition:
subu $sp $sp 4
sw $ra ($sp)

lw $t0 snakeDir
or $t0 0x2
bgtz $t0 horizontalMoving
li $v0 42
lw $a1 tailleGrille
syscall
move $t8 $a0
lw $a0 snakePosY
jal getRandomExcluding
move $t9 $v0
j endROPdir

horizontalMoving:
lw $a0 snakePosX
jal getRandomExcluding
move $t8 $v0
lw $a1 tailleGrille
li $v0 42
syscall
move $t9 $a0
endROPdir:

lw $t0 tailleSnake
sll $t0 $t0 2
la $t0 snakePosX($t0)
la $t1 snakePosX
la $t2 snakePosY
li $t4 0

ROPtestPos:
bge $t1 $t0 endROPtestPos
lw $t3 ($t1)
bne $t3 $t8 ROPtestPos2
lw $t3 ($t2)
beq $t3 $t9 replayROP
ROPtestPos2:
addu $t1 $t1 4
addu $t2 $t2 4
j ROPtestPos
endROPtestPos:

bnez $t4 endROP

lw $t0 numObstacles
sll $t0 $t0 2
la $t0 obstaclesPosX($t0)
la $t1 obstaclesPosX
la $t2 obstaclesPosY
li $t4 1
j ROPtestPos

endROP:
move $v0 $t8
move $v1 $t9
lw $ra ($sp)
addu $sp $sp 4
jr $ra

replayROP:
lw $ra ($sp)
addu $sp $sp 4
j newRandomObjectPosition

################################# getInputVal ##################################
# Paramètres: Aucun
# Retour: $v0 La valeur 0 (haut), 1 (droite), 2 (bas), 3 (gauche), 4 erreur
################################################################################

getInputVal:
lw $t0 0xffff0004
li $t1 115
beq $t0 $t1 GIhaut
li $t1 122
beq $t0 $t1 GIbas
li $t1 113
beq $t0 $t1 GIgauche
li $t1 100
beq $t0 $t1 GIdroite
li $v0 4
j GIend

GIhaut:
li $v0 0
j GIend

GIdroite:
li $v0 1
j GIend

GIbas:
li $v0 2
j GIend

GIgauche:
li $v0 3

GIend:
jr $ra

################################ sleepMillisec #################################
# Paramètres: $a0 Le temps en milli-secondes qu'il faut passer dans cette
#             fonction (approximatif)
# Retour: Aucun
################################################################################

sleepMillisec:
move $t0 $a0
li $v0 30
syscall
addu $t0 $t0 $a0

SMloop:
bgt $a0 $t0 endSMloop
li $v0 30
syscall
j SMloop

endSMloop:
jr $ra

##################################### main #####################################
# Description: Boucle principal du jeu
# Paramètres: Aucun
# Retour: Aucun
################################################################################

main:

# Initialisation du jeu

jal resetAffichage
jal newRandomObjectPosition
sw $v0 candy
sw $v1 candy + 4
# Boucle de jeu

mainloop:

jal getInputVal
move $a0 $v0
jal majDirection
jal updateGameStatus
jal conditionFinJeu
bnez $v0 gameOver
jal printGame
li $a0 500
jal sleepMillisec
j mainloop

gameOver:
jal affichageFinJeu
li $v0 10
syscall

################################################################################
#                                Partie Projet                                 #
################################################################################

# À vous de jouer !

.data
    score:     .asciiz         "  /$$$$$$                                         \n /$$__  $$                                        \n| $$  \\__/  /$$$$$$$  /$$$$$$   /$$$$$$   /$$$$$$ \n|  $$$$$$  /$$_____/ /$$__  $$ /$$__  $$ /$$__  $$\n \\____  $$| $$      | $$  \\ $$| $$  \\__/| $$$$$$$$\n /$$  \\ $$| $$      | $$  | $$| $$      | $$_____/\n|  $$$$$$/|  $$$$$$$|  $$$$$$/| $$      |  $$$$$$$\n \\______/  \\_______/ \\______/ |__/       \\_______/\n                                                  \n                                                  \n_______________________________________________________________________________________________________________________________________________\n"
tailleGrille:  .word 16        # Nombre de case du jeu dans une dimension.

# La tête du serpent se trouve à (snakePosX[0], snakePosY[0]) et la queue à
# (snakePosX[tailleSnake - 1], snakePosY[tailleSnake - 1])
tailleSnake:   .word 1         # Taille actuelle du serpent.
snakePosX:     .word 0 : 1024  # Coordonnées X du serpent ordonné de la tête à la queue.
snakePosY:     .word 0 : 1024  # Coordonnées Y du serpent ordonné de la t.

# Les directions sont représentés sous forme d'entier allant de 0 à 3:
snakeDir:      .word 1         # Direction du serpent: 0 (haut), 1 (droite)
                               #                       2 (bas), 3 (gauche)
numObstacles:  .word 0         # Nombre actuel d'obstacle présent dans le jeu.
obstaclesPosX: .word 0 : 1024  # Coordonnées X des obstacles
obstaclesPosY: .word 0 : 1024  # Coordonnées Y des obstacles
candy:         .word 0, 0      # Position du bonbon (X,Y)
scoreJeu:      .word 0         # Score obtenu par le joueur

.text

################################# majDirection #################################
# Paramètres: $a0 La nouvelle position demandée par l'utilisateur. La valeur
#                 étant le retour de la fonction getInputVal.
# Retour: Aucun
# Effet de bord: La direction du serpent à été mise à jour.
# Post-condition: La valeur du serpent reste intacte si une commande illégale
#                 est demandée, i.e. le serpent ne peut pas faire un demi-tour 
#                 (se retourner en un seul tour. Par exemple passer de la 
#                 direction droite à gauche directement est impossible (un 
#                 serpent n'est pas une chouette)
################################################################################

majDirection:
move $t0 $a0		#a0 contient la valeur de la touche pressé
lw $t2 snakeDir
beq $t0 0 haut		
beq $t0 2 bas 
beq $t0 1 droite
beq $t0 3 gauche

j finDirection


haut:
beq $t2 2 finDirection	#Comparaison avec l'ancienne valeur de snakeDir pour les directions interdites
li $v0, 0
sw $v0, snakeDir
j finDirection

bas:
beq $t2 0 finDirection	#Comparaison avec l'ancienne valeur de snakeDir pour les directions interdites
li $v0, 2
sw $v0, snakeDir 
j finDirection

gauche:
beq $t2 1 finDirection	#Comparaison avec l'ancienne valeur de snakeDir pour les directions interdites
li $v0, 3
sw $v0, snakeDir 
j finDirection

droite:
beq $t2 3 finDirection	#Comparaison avec l'ancienne valeur de snakeDir pour les directions interdites
li $v0, 1
sw $v0, snakeDir 
j finDirection

finDirection:
jr $ra

############################### updateGameStatus ###############################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: L'état du jeu est mis à jour d'un pas de temps. Il faut donc :
#                  - Faire bouger le serpent
#                  - Tester si le serpent à manger le bonbon
#                    - Si oui déplacer le bonbon et ajouter un nouvel obstacle
################################################################################

updateGameStatus:
  lw $t0 snakePosX     # Chargement de la position X du serpent
  lw $t1 snakePosY     # Chargement de la position X du serpent
  lw $t2 snakeDir      # Chargement de la direction actuelle du serpent
  lw $t3 candy($0)     # Chargement de la position X du candy
  li $t5 4
  li $t6 -4
  lw $t4 candy($t5)    # Chargement de la position Y du candys
  lw $t7 tailleSnake
  mul $t7 $t7 4
  subi $t7 $t7 4
  boucleCorps:
  ble $t7 $0 suiteCorpsDepla	#Déplacements du corps
  subi $t7 $t7 4		##Récupération des valeurs de la case d'avant
  lw $t0 snakePosX($t7)		##
  lw $t1 snakePosY($t7)		##
  addi $t7 $t7 4		###Ecriture des valeurs dans les cases de bases
  sw $t0 snakePosX($t7)		###
  sw $t1 snakePosY($t7)    	###
  subi $t7 $t7 4		#Passage à la case d'avant
  j boucleCorps			#
  suiteCorpsDepla:		#Fin déplacement corps
  beq $t2 0 uhaut		#branchements déplacement tête serpent
  beq $t2 1 udroite		#
  beq $t2 2 ubas		#
  beq $t2 3 ugauche		#
  j mangeCandy			#Si autre touche = skip
  			
  
    udroite:			#Déplacements de la tête
    lw $t1 snakePosY($t7)    	#
    addi $t1 $t1 1      	#Ajout de une unité sur l'axe Y
    sw $t1 snakePosY($t7)	#
    j mangeCandy		#
 				#
   ubas:			#
    lw $t1 snakePosX($0)	#
    subi $t0 $t0 1      	#Soustraction de une unité sur l'axe X
    sw $t0 snakePosX($0)    	#
    j mangeCandy    		#
  				#
  ugauche:			#
    lw $t1 snakePosY($t7)	#
    subi $t1 $t1 1      	#Soustraction de une unité sur l'axe Y
    sw $t1 snakePosY($t7)    	#
    j mangeCandy		#
  				#
  uhaut:			#
    lw $t1 snakePosX($t7)	#
    addi $t0 $t0 1      	#Ajout de une unité sur l'axe X
    sw $t0 snakePosX($t7)  	#
    j mangeCandy		#fin déplacement serpent
    
    
mangeCandy:
  lw $t0 snakePosX($0)     
  lw $t1 snakePosY($0)
   bne $t3 $t0 exitUpdt		##Conditions de collision avec le bonbon
   bne $t4 $t1 exitUpdt		##
   lw $t6 scoreJeu($0)		#Incrémentation score
   addi $t6 $t6 1		#
   sw $t6 scoreJeu($0)		#
      
   addi $t6 $t6 1		#Incrementation taille
   sw $t6 tailleSnake		#
   li $t1 -1
   mul $t6 $t6 4
   subi $t6 $t6 4
   sw $t1 snakePosX($t6)
   lw $t0 numObstacles($0)	#########################################
   addi $t0 $t0 1		# Ajout de l'obstacle après avoir mange #
   sw $t0 numObstacles($0)	#########################################
   move $t7 $ra
# Retour: $v0 Position X du nouvel objet
#        $v1 Position Y du nouvel objet
   jal newRandomObjectPosition
   lw $t6 tailleSnake
   mul $t6 $t6 4
   subi $t6 $t6 8
   sw $v0 obstaclesPosX($t6)
   sw $v1 obstaclesPosY($t6)

# Retour: $v0 Position X duœ nouvel objet
#         $v1 Position Y du nouvel objet
   jal newRandomObjectPosition
   sw $v0 candy($0)
   sw $v1 candy+4($0)
   move $ra $t7 
  j exitUpdt
# La tête du serpent se trouve à (snakePosX[0], snakePosY[0]) et la queue à
# (snakePosX[tailleSnake - 1], snakePosY[tailleSnake - 1])
exitUpdt:
    jr $ra


############################### conditionFinJeu ################################
# Paramètres: Aucun
# Retour: $v0 La valeur 0 si le jeu doit continuer ou toute autre valeur sinon.
################################################################################

conditionFinJeu:
li $t2 4
lw $t0 snakePosY($0)
lw $t1 snakePosX($0)
beq $t0 16 LeJeuStop		#Collision avec le mur droit
beq $t0 -1 LeJeuStop		#Collision avec le mur gauche
beq $t1 16 LeJeuStop		#Collision avec le bas
beq $t1 -1 LeJeuStop		#Collision avec le haut
lw $t5 numObstacles
mul $t5 $t5 4
li $t4 0

VerifObstacles:			#Verification de collision avec obstacles
lw $t3 obstaclesPosX($t4)	#
lw $t6 obstaclesPosY($t4)	#
beq $t4 $t5 CestGood		#Si tous les obstacles sont vérifiés, c'est bon
addi $t4 $t4 4			#
bne $t3 $t1 VerifObstacles	#Si la position X des deux cases sont les mêmes (elles ne sont pas, pas les mêmes), ca continues
beq $t6 $t0 LeJeuStop 		#Verifictation de la case Y
j VerifObstacles		#


CestGood:
li $t2 4
lw $t0 snakePosY($0)
lw $t1 snakePosX($0)
lw $t5 tailleSnake
mul $t5 $t5 4
VerifCorps:			#Vérification du corps dans la même logique que l'obstacle
lw $t3 snakePosX($t2)		#
lw $t6 snakePosY($t2)		#
beq $t2 $t5 suiteCondit		#
addi $t2 $t2 4			#
bne $t3 $t1 VerifCorps		#
beq $t6 $t0 LeJeuStop		#
j VerifCorps			#

suiteCondit:
li $v0 0 #ca veut dire continue
j finConditions

LeJeuStop:
li $v0 1
j finConditions

finConditions:
jr $ra


############################### affichageFinJeu ################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Affiche le score du joueur dans le terminal suivi d'un petit
#                mot gentil (Exemple : «Quelle pitoyable prestation!»).
# Bonus: Afficher le score en surimpression du jeu.
################################################################################

affichageFinJeu:
   li $v0, 4
   la $a0, score
   syscall
   lw $a0 scoreJeu($0)		# |affichage score
   li $v0 1			# |
   syscall			# |
# Fin.
jr $ra
