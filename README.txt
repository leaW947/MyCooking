
----------------------------------Introduction--------------------------

J'ai réalisai un jeu de cuisine en 2D avec le langage lua et le framework Love2D. 
J'ai programmé ce jeu avec l'IDE ZeroBrane Studio. Pour les graphismes, je les ai
fait moi-même avec PyxelEdit et Inkscape.

J'ai crée ce jeu en m'inspirant du jeu "Overcooked" et des jeux de cuisine qu'on
peux trouver fréquement sur le web.


----------------------Déroulement du jeu---------------------------------

Une fois qu'on lance le projet, on arrive directement sur l'écran de choix de 
niveaux.

	----Ecran de choix de niveaux

Tout d'abord, il y a affiché en haut à droite de l'écran, le nombre total
d'étoiles qu'on a gagner en réussissant les différents niveaux.
On peux gagner jusqu'à trois étoiles par niveau.

Ces étoiles servent à débloquer le niveau suivant celui auquel on vient de jouer(
Par exemple si on a jouer au niveau 1 et qu'on a réussi ce niveau, le niveau 
suivant qu'on pourra débloquer sera le niveau 2 uniquement, et un si de suite...).

Au milieu de l'écran, il y a les différents niveaux qui existent. Ils sont 
représentaient par des carrés bleu(bleu foncé pour les niveaux bloquaient et bleu clair
pour les niveaux débloquaient). Il y a aussi une pancarte à côté de chaque niveau 
indiquant leurs numéro.

A gauche de l'écran, il y a un petit camion qu'on peux diriger avec les flèches des
quatres directions du clavier(flèches: droite, gauche, haut et bas).
Lorsque ce camion arrive à une certaine distance d'un niveau, une bulle s'affiche
au niveau du carré bleu.

Si le niveau est débloqué la bulle sera gris clair sinon elle sera gris foncé.
	
	----jouer à un niveau
Pour jouer à un niveau : Il suffit que la bulle s'affiche, que le niveau soit 
débloquait et cliquer sur la touche entrée du clavier.

	---débloquer un niveau
Pour débloquer un niveau : Il faut que la bulle s'affiche, ensuite cliquer sur 
la touche entrée du clavier. Si on a assez d'étoiles pour débloquer le niveau, 
la bulle correspondante aux niveaux débloquaient s'affichera. Sinon un message d'erreur 
s'affichera à la place pendant un certain temps.


	----------Ecran de jeu---------------

	----principe du jeu-------
Une fois la partie démarrer, le but du jeu est de servir un maximum de client en 
respectant bien les commandes, en un minimum de temps.

Le chonomètre est affiché en haut à droite de l'écran(juste derrière le sablier).
Le nombre de client servie et satifait est affiché juste avant le sablier 
en haut à droite de l'écran aussi. 

Quand on sert un client et que la commande est bonne, le nombre de clients servient
augmente et on gagne de l'argent(affiché au milieu à droite de l'écran, sur la 
caisse enregistreuse). Si on a pas respecter la commande le client part énervé, le
nombre de clients servient n'augmente pas et on perd de l'argent. 

Plus on gagne de l'argent selon le nombre de clients qu'on doit au minimum servir, 
plus on gagne d'étoiles à la fin de la partie.

Attention: Si on ne prends pas assez vite la commande d'un client ou qu'on ne donne
pas assez vite ça commande prête au client. Le client part en colère et vous ne 
pourrez donc pas lui donné sa commande, ni gagner de l'argent sur cette commande.
Vous pouvez juste utiliser le plat que vous étiez entrain de préparer pour une autre
commande.


	----comment jouer---------
Pour commencer des clients arrivent et s'arrêtent devant le comptoir. Une fois le 
client arrêtait, une bulle s'affiche. Il faut cliquer sur la bulle pour pouvoir
prendre la commande.

Une fois la commande prise, un ticket s'affiche en haut de l'écran. Il y a sur ce 
ticket, le numéro de commande et un dessin correspondant au plat demandé. Il faut 
deviner qu'elles aliments correspondent au dessin indiquand le plat demandé.


Maintenant en cuisine!

Les aliments dont on aura besoin sont en bas à gauche de l'écran. 
Les ustensiles et objets de cuisine dont on aura besoin sont en bas à droite de l'écran.

	---ce servir des ustensiles/objets de cuisine----
Pour prendre un ustensile ou un objet, il suffit de cliquer sur l'îcone correspondant. Ensuite
il suffit de bouger la souris et l'ustensile bougera en même temps.

les objets de cuisine doivent être posaient. Pour cela il suffit de les posaient sur
leurs ombres correspondantent situés sur le plan de travail. Pour cela il suffit de
cliquer sur l'ombre correspondant à l'ustensile.

Les ustensiles ne peuvent pas être posaient, juste utilisaient. Ce sont des 
objets qui n'ont pas d'ombre sur le plan de travail. Si vous voulez plus utiliser
ce genre d'objet, il suffit de recliquer sur l'îcone correspondant et l'ustensile
disparaitra.

Si on veut jeter un aliment posait sur un objet (cela est possible uniquement si on a 
appliqué une modification à l'aliment). Il faut prendre l'objet et 
le diriger vers la poubelle situé tout en bas à droite de l'écran.
Lorsque l'objet touche la poubelle, l'aliment disparaitra et l'objet reprendra
sa place initiale.

	---ce servir des aliments------
Pour prendre un aliment il suffit aussi de cliquer sur l'îcone correspondant et de 
bouger la souris. 

Si on veut jeter l'aliment, il suffit de diriger cet aliment vers la poubelle
situé tout en bas à droite de l'écran (cela est possible uniquement si l'aliment n'est pas posait 
sur un objet). Une fois que l'aliment touche la poubelle, il disparaît.


	---------préparer le plat-----
Pour commencer, il faut prendre un aliment et le poser sur un objet pour le cuisiner. 
Pour cela il faut que l'objet soit posait sur son emplacement attitré. Ensuite il 
faut cliquer sur l'objet où on veux et où on peut poser l'aliment.

Si l'aliment ne ce pose pas sur l'objet sur lequel on a cliquer, c'est qu'on
doit poser l'aliment sur un autre objet.

Si on prend un ustensile qui donc ne peux pas être posait, c'est qu'il doit être utilisé
sur un aliment. Pour cela il faut prendre l'ustensile et ensuite cliquer sur 
l'aliment sur lequel on veut l'utiliser.

Si rien ne se passe lorsque qu'on clique sur l'aliment : 
C'est que soit l'ustensile ne peux pas être utilisé sur cet aliment, soit qu'il 
faut effectuer une autre opération sur cet aliment avant d'utilisé cet ustensile.

Une fois qu'un aliment est posait sur un objet et qu'on a effectuer le ou les
opérations qu'on devait effectuer à ce moment là. On peut cliquer sur l'objet
où ce trouve l'aliment et le diriger vers un autre objet et cliquer sur cette
autre objet pour tranvaser l'aliment en question et pour effectuer d'autre 
opération sur celui-ci.


Exemple plus clair d'utilisation:

	-Cuisiner une soupe:

-Il faut tout d'abords verser de l'eau dans la casserole.(prendre la bouteille d'eau
et cliquer sur la casserole).
-Ensuite prendre par exemple une tomate et la posait sur la planche à découper.
-Prendre le couteau, puis cliquer sur la tomate.
-Une fois la tomate découper, cliquer sur la planche à découper et la diriger vers la
casserole pleine d'eau.
-Cliquer sur la casserole et attendre que l'animation de cuisson soit terminé.
-Enfin prendre la casserole, la diriger vers le bole et cliquer sur le bole pour 
tranvaser la soupe.

Si on veut ajouter des croutons à notre soupe:

-Prendre le pain et le posait sur la planche à découper.
-prendre le couteau et cliquer sur le pain.
-une fois découper, prendre la planche à découper, la diriger vers le bole et cliquer
sur celui-ci.

Si on veut cuisiner une soupe de carrotte ou d'oignons par exemple, il faut éplucher
ces aliments avant de les découper.
-Prendre l'économe et cliquer sur l'aliment posait sur la planche à découper.
-Une fois l'aliment éplucher, on peut le découper.


	-Pour cuisiner un hotdog

-Prendre le pain à hotdog et le posait sur l'assiette
-Prendre la saucisse et la posait dans la poêle pour la faire cuir.
-Une fois cuite, prendre la poêle et cliquer sur l'assiette pour y posait la saucisse.
-Prendre ensuite la moutarde et/ou le ketchup et en verser dans l'assiette.

-Et pourquoi pas prendre le poivron et le posait sur la planche à découper.
-Ensuite prendre le couteau pour découper le poivron.
-Une fois découper prendre la planche à découper et cliquer sur la poêle pour faire
cuir le poivron.
-Et enfin prendre la poêle et cliquer sur l'assiette pour y posait ce poivron.

Il faut jouer à ce jeu avec une logique assez réaliste.

	----Plat prêt-------
Une fois la commande demandait prête, il faut pouvoir la donner au client. Pour cela il
faut tout d'abords cliquer sur le plat et ensuite cliquer sur le ticket correspondant
à ce plat.
Ensuite une sonnette retentit indiquant que la commande a bien été donné au client et le
ticket correspondant disparaît.


	---------victoire ou défaite---------

Si le chronométre est à 0, la partie est terminé.
	
	----victoire---
Si on a servit le minimum de client qu'on devait servir, on a gagner la partie. On
pourra rejouer plus tard à ce même niveau si on souhaite faire mieux.
De ce fait on pourra débloquer le niveau suivant si on a gagner assez détoiles 
jusque là.

	----défaite----
Si on a pas servit le minimum de client qu'on devait servir, on perd la partie. On 
ne pourra pas débloquer le niveau suivant. On peux évidement rejouer le niveau perdu
si on veut avancer dans le jeu.

