# Étape 1 : Utiliser une image de base avec Node.js préinstallé pour builder le projet

FROM node:14-alpine as builder

# Définir le répertoire de travail à l'intérieur du conteneur

WORKDIR /app

# Copier tous les fichiers du projet dans le répertoire de travail
# Installer les dépendances du projet

COPY ./try .

RUN npm install

# Exécuter la commande de build du projet


RUN npm run build 
# Étape 2 : Utiliser une image légère basée sur Nginx pour servir l'application buildée

FROM nginx:alpine

# Copier les fichiers buildés depuis l'étape précédente vers le répertoire de contenu de Nginx

COPY --from=builder /app/build /usr/share/nginx/html

# Exposer le port 80 pour le serveur Nginx

EXPOSE 80

# Définir la commande par défaut pour démarrer le serveur Nginx

CMD ["nginx", "-g", "daemon off;"]