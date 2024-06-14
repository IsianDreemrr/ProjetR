# ProjetR
Prédiction des Prix des Maisons
Description du Projet
Ce projet utilise un modèle de deep learning pour prédire les prix des maisons à partir de diverses caractéristiques immobilières. Le modèle a été entraîné sur un jeu de données nettoyé et traité pour assurer la meilleure performance de prédiction possible. Le modèle final, le "Model 3", a démontré une haute précision et est intégré dans une application Shiny pour permettre des prédictions en temps réel.

Fonctionnalités
Prédiction en temps réel : Utilisez l'application Shiny pour saisir les caractéristiques d'une maison et recevez une estimation de prix instantanée.
Modèle de deep learning robuste : Le modèle est entraîné avec des techniques avancées de deep learning pour assurer une prédiction précise.
Interface utilisateur intuitive : L'application Shiny offre une interface claire et facile à utiliser.
Technologies Utilisées
R : Tout le traitement des données, l'analyse exploratoire et le développement du modèle ont été réalisés en R.
Keras et TensorFlow : Utilisés pour construire et entraîner le modèle de deep learning.
Shiny : Pour développer l'interface utilisateur de l'application web permettant les prédictions des prix des maisons.
Structure du Projet
data/
Dataset_House_data.csv : Le jeu de données original.
Cleaned_Dataset_House_data.csv : Le jeu de données nettoyé utilisé pour l'entraînement du modèle.
models/
house_price_prediction_model.h5 : Le modèle de prédiction des prix des maisons sauvegardé.
app/
app.R : Script de l'application Shiny pour la prédiction des prix des maisons.
notebooks/
Data_Cleaning_and_Analysis.ipynb : Notebook pour le nettoyage et l'analyse des données.
Model_Training.ipynb : Notebook pour l'entraînement des modèles.
DataBase/
Mysql
Installation et Exécution
Cloner le dépôt :
bash
Copier le code
git clone [https://github.com/votre-username/votre-repo.git](https://github.com/IsianDreemrr/ProjetR)
cd votre-repo
Installer les dépendances (assurez-vous d'avoir R et RStudio installés) :
R
Copier le code
install.packages("shiny")
install.packages("keras")
install.packages("tensorflow")
Lancer l'application Shiny :
R
Copier le code
shiny::runApp('app/')
Contribution
Les contributions à ce projet sont les bienvenues. Pour proposer des améliorations ou signaler des bugs, veuillez ouvrir une issue ou soumettre une pull request.

Licence
Ce projet est sous licence MIT. Veuillez voir le fichier LICENSE pour plus de détails.

Contact
Pour plus d'informations, contactez Votre Nom.

Ce README est conçu pour donner un aperçu clair et professionnel de votre projet, en soulignant les points clés et en facilitant l'utilisation et la contribution par d'autres utilisateurs ou développeurs.
 
